
//----------------------------------------------------------------
// 0. Housekeeping
//----------------------------------------------------------------

close all

//----------------------------------------------------------------
// 1. Variáveis endógenas (3=2+1)
//----------------------------------------------------------------

var
c k

// Shocks
z;

//----------------------------------------------------------------
// 2. Exogenous variables (1)
//----------------------------------------------------------------

varexo

ez;

//----------------------------------------------------------------
// 3. Parameters
//----------------------------------------------------------------

parameters

bbeta aalpha rrho ssigma;

//----------------------------------------------------------------
// 4. Calibration
//----------------------------------------------------------------

bbeta       = 0.99;
aalpha      = 0.33;
rrho        = 0.95;
ssigma      = 0.01;

//----------------------------------------------------------------
// 4. Steady State
//----------------------------------------------------------------

kss = (aalpha * bbeta)^(1/(1-aalpha));
css = (aalpha * bbeta)^(aalpha/(1-aalpha)) - kss;

//----------------------------------------------------------------
// 5. Model
//----------------------------------------------------------------

model;

  // 1. consumption
  1 = bbeta * (c/c(+1)) * aalpha * exp(z(+1))*k^(aalpha - 1);

  // 2. capital
  k(-1)^aalpha * exp(z) = c + k;

  // 3. Productivity process
  z = rrho*z(-1) + ssigma*ez;

end;

//----------------------------------------------------------------
// 6. Computation
//----------------------------------------------------------------

initval;
  c      = css;
  k      = kss;
  z      = 0;
  ez     = 0;
end;

shocks;
	var ez = 1;
end;

steady;

check;

stoch_simul(hp_filter = 1600, irf = 20, order = 1) k c z;