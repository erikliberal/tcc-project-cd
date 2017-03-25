package org.unitee;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.Serializable;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.net.URL;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;

import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.inject.Produces;
import javax.enterprise.inject.spi.InjectionPoint;
import javax.inject.Qualifier;
import javax.naming.InitialContext;

import org.jboss.weld.environment.se.Weld;
import org.jboss.weld.environment.se.WeldContainer;
import org.junit.runner.Runner;
import org.junit.runners.BlockJUnit4ClassRunner;
import org.junit.runners.Suite;
import org.junit.runners.model.FrameworkMethod;
import org.junit.runners.model.InitializationError;
import org.junit.runners.model.RunnerBuilder;
import org.junit.runners.model.Statement;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class Parameterized extends Suite {


	@Qualifier
	@Retention(RetentionPolicy.RUNTIME)
	@Target(ElementType.TYPE)
	public static @interface Parameters {
		String name() default "{{index}}";

		String value();
	}

	@Qualifier
	@Retention(RetentionPolicy.RUNTIME)
	@Target({ ElementType.FIELD, ElementType.METHOD })
	public static @interface Parameter {
	}

	public static class BlockJUnit4CdiClassRunner extends BlockJUnit4ClassRunner {
		private final JsonObject testCase;
		private final Class<?> klass;
		private WeldContainer container;
		private Weld weld;
		public BlockJUnit4CdiClassRunner(Class<?> klass, JsonObject testCase) throws InitializationError {
			super(klass);
			this.testCase = testCase;
			this.klass = klass;
		}

		@Override
		protected Object createTest() throws Exception {
			
			try {

				weld = new Weld();
				try {

					container = weld.initialize();
				} catch (Throwable e) {
					if (e instanceof ClassFormatError) {
						throw e;
					}
				}

			} catch (ClassFormatError e) {

			}

			return createTest(klass);
		}

		private <T> T createTest(Class<T> testClass) {
			container.instance().select(ParameterProvider.class).get();
			T t = container.instance().select(testClass).get();
			return t;
		}

		@Override
		protected Statement methodBlock(final FrameworkMethod method) {
			final Statement defaultStatement = super.methodBlock(method);
			return new Statement() {

				@Override
				public void evaluate() throws Throwable {
					InitialContext initialContext = new InitialContext();
					initialContext.bind("java:comp/BeanManager", container.getBeanManager());

					try {
						defaultStatement.evaluate();
					} finally {
						initialContext.close();
						weld.shutdown();
					}

				}
			};

		}
	}

	private static final List<Runner> NO_RUNNERS = Collections.<Runner>emptyList();

	private final List<Runner> runners;

	/**
	 * Only called reflectively. Do not use programmatically.
	 */

	@ApplicationScoped
	public static class ParameterProvider implements Serializable {

		private static final long serialVersionUID = 1L;

		private JsonObject parameterHolder;

		public JsonObject getParameterHolder() {
			return parameterHolder;
		}

		public void setParameterHolder(JsonObject parameterHolder) {
			this.parameterHolder = parameterHolder;
		}

		@Parameter
		@Produces
		public Object Produces(InjectionPoint ip) {
			String name = ip.getMember().getName();
			return new Gson().fromJson(parameterHolder.get(name), ip.getType());
		}

	}

	private Collection<JsonObject> fromElement(JsonElement element) {
		if (element.isJsonObject())
			return Collections.singletonList(element.getAsJsonObject());
		List<JsonObject> result = new ArrayList<>();
		if (element.isJsonArray()) {
			for (Iterator<JsonElement> iterator = element.getAsJsonArray().iterator(); iterator.hasNext();) {
				JsonElement jsonElement = iterator.next();
				if (jsonElement.isJsonObject())
					result.add(jsonElement.getAsJsonObject());
			}
		}
		return result;
	}

	public Parameterized(Class<?> klass) throws Throwable {
		super(klass, NO_RUNNERS);
		
		Parameters parameters = getTestClass().getAnnotation(Parameters.class);

		List<Runner> runners = new ArrayList<>();
		for (Enumeration<URL> resources = ClassLoader.getSystemClassLoader().getResources(
				Paths.get(klass.getName(), parameters.value()).toString()); resources.hasMoreElements();) {
			URL resource = resources.nextElement();
			try (InputStream is = resource.openStream()) {
				if (is != null) {
					try (Reader r = new InputStreamReader(is)) {
						JsonElement jsonElement = new JsonParser().parse(r);
						for (JsonObject jsonObject : fromElement(jsonElement)) {
							runners.add(new BlockJUnit4CdiClassRunner(getTestClass().getJavaClass(), jsonObject));
						}
					}
				}
			}
			break;
		}
		this.runners = Collections.unmodifiableList(runners);
	}

	@Override
	protected List<Runner> getChildren() {
		return runners;
	}

}
