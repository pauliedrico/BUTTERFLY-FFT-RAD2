a_r=-0.424194;
a_i=0.535217;
b_r=0.342133;
b_i=-0.324371;
w_r=0.5;
w_i=-0.5;

out_AR=(a_r+(b_r*w_r)-(b_i*w_i));
out_AI=(a_i+(b_r*w_i)+(b_i*w_r));
out_BR=(-out_AR+2*a_r);
out_BI=(2*a_i-out_AI);
SCALED_AR=out_AR/4;
SCALED_AI=out_AI/4;
SCALED_BR=out_BR/4;
SCALED_BI=out_BI/4;