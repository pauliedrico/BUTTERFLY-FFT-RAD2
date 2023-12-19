W_0_R = 1
W_0_I = 0
W_1_R = 0.923879
W_1_I = -0.382683
W_2_R = 0.707107
W_2_I = -0.707107
W_3_R = 0.382683
W_3_I = -0.923879
W_4_R = 0
W_4_I = -1
W_5_R = -0.382683
W_5_I = -0.923879
W_6_R = -0.707107
W_6_I = -0.707107
W_7_R = -0.923879
W_7_I = -0.382683

###################
X_0_R = 1
X_0_I = 1
X_1_R = 1
X_1_I = 1
X_2_R = 1
X_2_I = 1
X_3_R = 1
X_3_I = 1
X_4_R = 1
X_4_I = 1
X_5_R = 1
X_5_I = 1
X_6_R = 1
X_6_I = 1
X_7_R = 1
X_7_I = 1
X_8_R = 1
X_8_I = 1
X_9_R = 1
X_9_I = 1
X_10_R = 1
X_10_I = 1
X_11_R = 1
X_11_I = 1
X_12_R = 1
X_12_I = 1
X_13_R = 1
X_13_I = 1
X_14_R = 1
X_14_I = 1
X_15_R = 1
X_15_I = 1


###################

def butterfly(a_r, a_i, b_r, b_i, w_r, w_i, Scale):
    out_AR = (a_r + (b_r * w_r) - (b_i * w_i))
    out_AI = (a_i + (b_r * w_i) + (b_i * w_r))
    out_BR = (-out_AR + 2 * a_r)
    out_BI = (2 * a_i - out_AI)
    if Scale == 1:
        out_AR_S = out_AR / 4
        out_AI_S = out_AI / 4
        out_BR_S = out_BR / 4
        out_BI_S = out_BI / 4
    else:
        out_AR_S = out_AR / 2
        out_AI_S = out_AI / 2
        out_BR_S = out_BR / 2
        out_BI_S = out_BI / 2
    return out_AR_S, out_AI_S, out_BR_S, out_BI_S


# Step 1
Y0_R, Y0_I, Y8_R, Y8_I = butterfly(X_0_R, X_0_I, X_8_R, X_8_I, W_0_R, W_0_I, 1)
Y1_R, Y1_I, Y9_R, Y9_I = butterfly(X_1_R, X_1_I, X_9_R, X_9_I, W_0_R, W_0_I, 1)
Y2_R, Y2_I, Y10_R, Y10_I = butterfly(X_2_R, X_2_I, X_10_R, X_10_I, W_0_R, W_0_I, 1)
Y3_R, Y3_I, Y11_R, Y11_I = butterfly(X_3_R, X_3_I, X_11_R, X_11_I, W_0_R, W_0_I, 1)
Y4_R, Y4_I, Y12_R, Y12_I = butterfly(X_4_R, X_4_I, X_12_R, X_12_I, W_0_R, W_0_I, 1)
Y5_R, Y5_I, Y13_R, Y13_I = butterfly(X_5_R, X_5_I, X_13_R, X_13_I, W_0_R, W_0_I, 1)
Y6_R, Y6_I, Y14_R, Y14_I = butterfly(X_6_R, X_6_I, X_14_R, X_14_I, W_0_R, W_0_I, 1)
Y7_R, Y7_I, Y15_R, Y15_I = butterfly(X_7_R, X_7_I, X_15_R, X_15_I, W_0_R, W_0_I, 1)
# Step 2
Z0_R, Z0_I, Z4_R, Z4_I = butterfly(Y0_R, Y0_I, Y4_R, Y4_I, W_0_R, W_0_I, 0)
Z1_R, Z1_I, Z5_R, Z5_I = butterfly(Y1_R, Y1_I, Y5_R, Y5_I, W_0_R, W_0_I, 0)
Z2_R, Z2_I, Z6_R, Z6_I = butterfly(Y2_R, Y2_I, Y6_R, Y6_I, W_0_R, W_0_I, 0)
Z3_R, Z3_I, Z7_R, Z7_I = butterfly(Y3_R, Y3_I, Y7_R, Y7_I, W_0_R, W_0_I, 0)
Z8_R, Z8_I, Z12_R, Z12_I = butterfly(Y8_R, Y8_I, Y12_R, Y12_I, W_4_R, W_4_I, 0)
Z9_R, Z9_I, Z13_R, Z13_I = butterfly(Y9_R, Y9_I, Y13_R, Y13_I, W_4_R, W_4_I, 0)
Z10_R, Z10_I, Z14_R, Z14_I = butterfly(Y10_R, Y10_I, Y14_R, Y14_I, W_4_R, W_4_I, 0)
Z11_R, Z11_I, Z15_R, Z15_I = butterfly(Y11_R, Y11_I, Y15_R, Y15_I, W_4_R, W_4_I, 0)
# Step 3
T0_R, T0_I, T2_R, T2_I = butterfly(Z0_R, Z0_I, Z2_R, Z2_I, W_0_R, W_0_I, 0)
T1_R, T1_I, T3_R, T3_I = butterfly(Z1_R, Z1_I, Z3_R, Z3_I, W_0_R, W_0_I, 0)
T4_R, T4_I, T6_R, T6_I = butterfly(Z4_R, Z4_I, Z6_R, Z6_I, W_4_R, W_4_I, 0)
T5_R, T5_I, T7_R, T7_I = butterfly(Z5_R, Z5_I, Z7_R, Z7_I, W_4_R, W_4_I, 0)
T8_R, T8_I, T10_R, T10_I = butterfly(Z8_R, Z8_I, Z10_R, Z10_I, W_2_R, W_2_I, 0)
T9_R, T9_I, T11_R, T11_I = butterfly(Z9_R, Z9_I, Z11_R, Z11_I, W_2_R, W_2_I, 0)
T12_R, T12_I, T14_R, T14_I = butterfly(Z12_R, Z12_I, Z14_R, Z14_I, W_6_R, W_6_I, 0)
T13_R, T13_I, T15_R, T15_I = butterfly(Z13_R, Z13_I, Z15_R, Z15_I, W_6_R, W_6_I, 0)
# Step 4
X0_R_out, X0_I_out, X8_R_out, X8_I_out = butterfly(T0_R, T0_I, T1_R, T1_I, W_0_R, W_0_I, 0)
X4_R_out, X4_I_out, X12_R_out, X12_I_out = butterfly(T2_R, T2_I, T3_R, T3_I, W_4_R, W_4_I, 0)
X2_R_out, X2_I_out, X10_R_out, X10_I_out = butterfly(T4_R, T4_I, T5_R, T5_I, W_2_R, W_2_I, 0)
X6_R_out, X6_I_out, X14_R_out, X14_I_out = butterfly(T6_R, T6_I, T7_R, T7_I, W_6_R, W_6_I, 0)
X1_R_out, X1_I_out, X9_R_out, X9_I_out = butterfly(T8_R, T8_I, T9_R, T9_I, W_1_R, W_1_I, 0)
X5_R_out, X5_I_out, X13_R_out, X13_I_out = butterfly(T10_R, T10_I, T11_R, T11_I, W_5_R, W_5_I, 0)
X3_R_out, X3_I_out, X11_R_out, X11_I_out = butterfly(T12_R, T12_I, T13_R, T13_I, W_3_R, W_3_I, 0)
X7_R_out, X7_I_out, X15_R_out, X15_I_out = butterfly(T14_R, T14_I, T15_R, T15_I, W_7_R, W_7_I, 0)

############################
print("X0_R_out=" + str(X0_R_out/16))
print("X0_I_out=" + str(X0_I_out/16))
print("X1_R_out=" + str(X1_R_out/16))
print("X1_I_out=" + str(X1_I_out/16))
print("X2_R_out=" + str(X2_R_out/16))
print("X2_I_out=" + str(X2_I_out/16))
print("X3_R_out=" + str(X3_R_out/16))
print("X3_I_out=" + str(X3_I_out/16))
print("X4_R_out=" + str(X4_R_out/16))
print("X4_I_out=" + str(X4_I_out/16))
print("X5_R_out=" + str(X5_R_out/16))
print("X5_I_out=" + str(X5_I_out/16))
print("X6_R_out=" + str(X6_R_out/16))
print("X6_I_out=" + str(X6_I_out/16))
print("X7_R_out=" + str(X7_R_out/16))
print("X7_I_out=" + str(X7_I_out/16))
print("X8_R_out=" + str(X8_R_out/16))
print("X8_I_out=" + str(X8_I_out/16))
print("X9_R_out=" + str(X9_R_out/16))
print("X9_I_out=" + str(X9_I_out/16))
print("X10_R_out=" + str(X10_R_out/16))
print("X10_I_out=" + str(X10_I_out/16))
print("X11_R_out=" + str(X11_R_out/16))
print("X11_I_out=" + str(X11_I_out/16))
print("X12_R_out=" + str(X12_R_out/16))
print("X12_I_out=" + str(X12_I_out/16))
print("X13_R_out=" + str(X13_R_out/16))
print("X13_I_out=" + str(X13_I_out/16))
print("X14_R_out=" + str(X14_R_out/16))
print("X14_I_out=" + str(X14_I_out/16))
print("X15_R_out=" + str(X15_R_out/16))
print("X15_I_out=" + str(X15_I_out/16))
