package unitee.testCase;

import javax.inject.Inject;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.unitee.Parameterized;
import org.unitee.Parameterized.Parameter;
import org.unitee.Parameterized.Parameters;

@RunWith(Parameterized.class)
@Parameters(value="TestCase1.json", name="Testa soma de {{valor1}} e {{valor2}} resultando em {{resultado}}")
public class TestCase {

	@Inject
	@Parameter
	private String casoTeste;
	@Inject
	@Parameter
	private Long valor1;
	@Inject
	@Parameter
	private Long valor2;
	@Inject
	@Parameter
	private Long resultado;

	@Test
	public void mainTesteUm() {
		Long calculado = valor1+valor2;
		Assert.assertEquals("Resultado "+casoTeste, calculado, resultado);
	}

}
