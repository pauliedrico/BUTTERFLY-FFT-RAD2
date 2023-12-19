import numpy as np 
from numpy import random
import matplotlib.pyplot as plt
from math import sqrt
import os
import subprocess

a_r = ((random.rand(200) - 0.5)*2)
a_i = ((random.rand(200) - 0.5)*2)
b_r = ((random.rand(200) - 0.5)*2)
b_i = ((random.rand(200) - 0.5)*2)
w_r = ((random.rand(200) - 0.5)*2)

w_i = []
i=0

#VETTORI PER PLOT
vecAR_py = []
vecAI_py = []
vecBR_py = []
vecBI_py = []
vecAR_sim = []
vecAI_sim = []
vecBR_sim = []
vecBI_sim = []
vecErr_AR = []
vecErr_AI = []
vecErr_BR = []
vecErr_BI = []

file_input_A_R = "inputs_A_R.txt"
file_input_A_I = "inputs_A_I.txt"
file_input_B_R = "inputs_B_R.txt"
file_input_B_I = "inputs_B_I.txt"
file_input_W_R = "inputs_W_R.txt"
file_input_W_I = "inputs_W_I.txt"

file_output_A_R_py = "output_A_R_py.txt"
file_output_A_I_py = "output_A_I_py.txt"
file_output_B_R_py = "output_B_R_py.txt"
file_output_B_I_py = "output_B_I_py.txt"

with open(file_input_A_R, 'w') as p1:
    with open(file_input_A_I, 'w') as p2:
        with open(file_input_B_R, 'w') as p3:
            with open(file_input_B_I, 'w') as p4:
                with open(file_input_W_R, 'w') as p5:
                    with open(file_input_W_I, 'w') as p6:
                        with open(file_output_A_R_py, 'w') as p7:
                            with open(file_output_A_I_py, 'w') as p8:
                                with open(file_output_B_R_py, 'w') as p9:
                                    with open(file_output_B_I_py, 'w') as p10:
                                        for i1,i2,i3,i4,i5 in zip(a_r,a_i,b_r,b_i,w_r):
                                            w_i.append(sqrt(1-(i5**2)))
                                            print(i1, file=p1)
                                            print(i2, file=p2)
                                            print(i3, file=p3)
                                            print(i4, file=p4)
                                            print(i5, file=p5)
                                            print(w_i[i], file=p6)
                                            #process (SIMULO BUTTERFLY in Py)
                                            out_AR = (i1 + (i3 * i5) - (i4 * w_i[i]))
                                            out_AI = (i2 + (i3 * w_i[i]) + (i4 * i5))
                                            out_BR = (-out_AR + 2 * i1)
                                            out_BI = (2 * i2 - out_AI)
                                            # RIEMPIO VETTORI PER PLOT Py
                                            vecAR_py.append(out_AR)
                                            vecAI_py.append(out_AI)
                                            vecBR_py.append(out_BR)
                                            vecBI_py.append(out_BI)
                                            #end process
                                            print(out_AR, file=p7)
                                            print(out_AI, file=p8)
                                            print(out_BR, file=p9)
                                            print(out_BI, file=p10)
                                            i+=1
                                    p10.close()
                                p9.close()
                            p8.close()
                        p7.close()
                    p6.close()
                p5.close()
            p4.close()
        p3.close()
    p2.close()
p1.close()

###########

# Launch Modelsim simulation
print ("Starting simulation...")
#DEVO ESEGUIRE DA DESKTOP!!!vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
process = subprocess.call(["../../intelFPGA_lite/20.1/modelsim_ase/bin/vsim", "-c", "-do", "compile.do"]) 
print ("Simulation completed")

#######################

file_output_A_R_sim = "output_A_R_sim.txt"
file_output_A_I_sim = "output_A_I_sim.txt"
file_output_B_R_sim = "output_B_R_sim.txt"
file_output_B_I_sim = "output_B_I_sim.txt"

file_log_A_R = "log_A_R.txt"
file_log_A_I = "log_A_I.txt"
file_log_B_R = "log_B_R.txt"
file_log_B_I = "log_B_I.txt"

#CONTATORI ERRORI
i1=0
i2=0
i3=0
i4=0

with open(file_output_A_R_py, 'r') as p1:
    with open(file_output_A_I_py, 'r') as p2:
        with open(file_output_B_R_py, 'r') as p3:
            with open(file_output_B_I_py, 'r') as p4:
                with open(file_output_A_R_sim, 'r') as p5:
                    with open(file_output_A_I_sim, 'r') as p6:
                        with open(file_output_B_R_sim, 'r') as p7:
                            with open(file_output_B_I_sim, 'r') as p8:
                                with open(file_log_A_R, 'w') as p9:
                                    with open(file_log_A_I, 'w') as p10:
                                        with open(file_log_B_R, 'w') as p11:
                                            with open(file_log_B_I, 'w') as p12:
                                                for AR_py,AI_py,BR_py,BI_py,AR_sim,AI_sim,BR_sim,BI_sim in zip(p1,p2,p3,p4,p5,p6,p7,p8):
                                                    # RIEMPIO VETTORI PER PLOT Py
                                                    vecAR_sim.append(float(AR_sim)*2)
                                                    vecAI_sim.append(float(AI_sim)*2)
                                                    vecBR_sim.append(float(BR_sim)*2)
                                                    vecBI_sim.append(float(BI_sim)*2)
                                                    vecErr_AR.append(abs(float(AR_py)-float(AR_sim)*2))
                                                    vecErr_AI.append(abs(float(AI_py)-float(AI_sim)*2))
                                                    vecErr_BR.append(abs(float(BR_py)-float(BR_sim)*2))
                                                    vecErr_BI.append(abs(float(BI_py)-float(BI_sim)*2))
                                                    if abs(float(AR_py)-float(AR_sim)*2) > pow(2,-11) :
                                                        print(float(AR_py),'\t',float(AR_sim)*2,'\t',"--ERRORE--",'\n', file=p9)
                                                        i1+=1
                                                    else:
                                                        print(float(AR_py),'\t',float(AR_sim)*2,'\t',"--OK--",'\n', file=p9)    
                                                    if abs(float(AI_py)-float(AI_sim)*2) > pow(2,-11) :
                                                        print(float(AI_py),'\t',float(AI_sim)*2,'\t',"--ERRORE--",'\n', file=p10)
                                                        i2+=1
                                                    else:
                                                        print(float(AI_py),'\t',float(AI_sim)*2,'\t',"--OK--",'\n', file=p10)
                                                    if abs(float(BR_py)-float(BR_sim)*2) > pow(2,-11) :
                                                        print(float(BR_py),'\t',float(BR_sim)*2,'\t',"--ERRORE--",'\n', file=p11)
                                                        i3+=1
                                                    else:
                                                        print(float(BR_py),'\t',float(BR_sim)*2,'\t',"--OK--",'\n', file=p11)
                                                    if abs(float(BI_py)-float(BI_sim)*2) > pow(2,-11) :
                                                        print(float(BI_py),'\t',float(BI_sim)*2,'\t',"--ERRORE--",'\n', file=p12)
                                                        i4+=1
                                                    else:
                                                        print(float(BI_py),'\t',float(BI_sim)*2,'\t',"--OK--",'\n', file=p12)
                                            p12.close()
                                        p11.close()
                                    p10.close()
                                p9.close()
                            p8.close()
                        p7.close()
                    p6.close()
                p5.close()
            p4.close()
        p3.close()
    p2.close()
p1.close()

print("Percentuale output Ar con errore > 2^-11 = %.3f %%" % (i1*100/200))
print("Percentuale output Ai con errore > 2^-11 = %.3f %%" % (i2*100/200))
print("Percentuale output Br con errore > 2^-11 = %.3f %%" % (i3*100/200))
print("Percentuale output Bi con errore > 2^-11 = %.3f %%" % (i4*100/200))

#TIME BASE PER PLOT

time_base = np.linspace(0,1,200)

#PLOT AR

plt.figure(1)
plt.plot(time_base[:-2],vecAR_py[:-2],"-x",label="Python OUT")
plt.plot(time_base[:-2],vecAR_sim,"-x",label="ModelSim OUT")
plt.title("Python vs ModelSim (Ar)")
plt.legend()

#PLOT AI

plt.figure(2)
plt.plot(time_base[:-2],vecAI_py[:-2],"-x",label="Python OUT")
plt.plot(time_base[:-2],vecAI_sim,"-x",label="ModelSim OUT")
plt.title("Python vs ModelSim (Ai)")
plt.legend()

#PLOT BR

plt.figure(3)
plt.plot(time_base[:-2],vecBR_py[:-2],"-x",label="Python OUT")
plt.plot(time_base[:-2],vecBR_sim,"-x",label="ModelSim OUT")
plt.title("Python vs ModelSim (Br)")
plt.legend()

#PLOT BI

plt.figure(4)
plt.plot(time_base[:-2],vecBI_py[:-2],"-x",label="Python OUT")
plt.plot(time_base[:-2],vecBI_sim,"-x",label="ModelSim OUT")
plt.title("Python vs ModelSim (Bi)")
plt.legend()

#PLOT ERROR AR

plt.figure(5)
plt.plot(time_base[:-2],vecErr_AR,"-x")
plt.title("Andamento errori (Ar)")

#PLOT ERROR AI

plt.figure(6)
plt.plot(time_base[:-2],vecErr_AI,"-x")
plt.title("Andamento errori (Ai)")

#PLOT ERROR BR

plt.figure(7)
plt.plot(time_base[:-2],vecErr_BR,"-x")
plt.title("Andamento errori (Br)")

#PLOT ERROR BI

plt.figure(8)
plt.plot(time_base[:-2],vecErr_BI,"-x")
plt.title("Andamento errori (Bi)")

plt.show()




