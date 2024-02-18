# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -timeline -timeline-max-iterations=3 < %s | FileCheck %s

# TODO: Fix the processor resource usage for zero-idiom YMM XOR instructions.
#       Those vector XOR instructions should only consume 1cy of JFPU1 (instead
#       of 2cy).

# LLVM-MCA-BEGIN ZERO-IDIOM-1

vaddps %ymm0, %ymm0, %ymm1
vxorps %ymm1, %ymm1, %ymm1
vblendps $2, %ymm1, %ymm2, %ymm3

# LLVM-MCA-END

# LLVM-MCA-BEGIN ZERO-IDIOM-2

vaddpd %ymm0, %ymm0, %ymm1
vxorpd %ymm1, %ymm1, %ymm1
vblendpd $2, %ymm1, %ymm2, %ymm3

# LLVM-MCA-END

# LLVM-MCA-BEGIN ZERO-IDIOM-3
vaddps %ymm0, %ymm1, %ymm2
vandnps %ymm2, %ymm2, %ymm3
# LLVM-MCA-END

# LLVM-MCA-BEGIN ZERO-IDIOM-4
vaddps %ymm0, %ymm1, %ymm2
vandnps %ymm2, %ymm2, %ymm3
# LLVM-MCA-END

# LLVM-MCA-BEGIN ZERO-IDIOM-5
vperm2f128 $136, %ymm0, %ymm0, %ymm1
vaddps  %ymm1, %ymm1, %ymm0
# LLVM-MCA-END

# CHECK:      [0] Code Region - ZERO-IDIOM-1

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      300
# CHECK-NEXT: Total Cycles:      205
# CHECK-NEXT: Total uOps:        600

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    2.93
# CHECK-NEXT: IPC:               1.46
# CHECK-NEXT: Block RThroughput: 2.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      5     1.00                        vaddps	%ymm0, %ymm0, %ymm1
# CHECK-NEXT:  2      2     1.00                        vxorps	%ymm1, %ymm1, %ymm1
# CHECK-NEXT:  2      2     1.00                        vblendps	$2, %ymm1, %ymm2, %ymm3

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00   2.00   2.00    -      -     1.00    -     2.00   2.00    -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00    -      -      -      -     1.00    -      -      -      -      -      -      -      -     vaddps	%ymm0, %ymm0, %ymm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -     2.00    -      -      -      -      -     2.00    -      -      -      -      -     vxorps	%ymm1, %ymm1, %ymm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     2.00    -      -      -      -      -     2.00    -      -      -      -      -      -     vblendps	$2, %ymm1, %ymm2, %ymm3

# CHECK:      Timeline view:
# CHECK-NEXT:                     0
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeER  .   vaddps	%ymm0, %ymm0, %ymm1
# CHECK-NEXT: [0,1]     DeeE---R  .   vxorps	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: [0,2]     .D=eeE-R  .   vblendps	$2, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: [1,0]     .DeeeeeER .   vaddps	%ymm0, %ymm0, %ymm1
# CHECK-NEXT: [1,1]     . DeeE--R .   vxorps	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: [1,2]     . D==eeER .   vblendps	$2, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: [2,0]     .  DeeeeeER   vaddps	%ymm0, %ymm0, %ymm1
# CHECK-NEXT: [2,1]     .  D=eeE--R   vxorps	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: [2,2]     .   D==eeER   vblendps	$2, %ymm1, %ymm2, %ymm3

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     1.0    1.0    0.0       vaddps	%ymm0, %ymm0, %ymm1
# CHECK-NEXT: 1.     3     1.3    1.3    2.3       vxorps	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: 2.     3     2.7    0.0    0.3       vblendps	$2, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:        3     1.7    0.8    0.9       <total>

# CHECK:      [1] Code Region - ZERO-IDIOM-2

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      300
# CHECK-NEXT: Total Cycles:      205
# CHECK-NEXT: Total uOps:        600

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    2.93
# CHECK-NEXT: IPC:               1.46
# CHECK-NEXT: Block RThroughput: 2.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      5     1.00                        vaddpd	%ymm0, %ymm0, %ymm1
# CHECK-NEXT:  2      2     1.00                        vxorpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT:  2      2     1.00                        vblendpd	$2, %ymm1, %ymm2, %ymm3

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00   2.00   2.00    -      -     1.00    -     2.00   2.00    -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00    -      -      -      -     1.00    -      -      -      -      -      -      -      -     vaddpd	%ymm0, %ymm0, %ymm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -     2.00    -      -      -      -      -     2.00    -      -      -      -      -     vxorpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     2.00    -      -      -      -      -     2.00    -      -      -      -      -      -     vblendpd	$2, %ymm1, %ymm2, %ymm3

# CHECK:      Timeline view:
# CHECK-NEXT:                     0
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeER  .   vaddpd	%ymm0, %ymm0, %ymm1
# CHECK-NEXT: [0,1]     DeeE---R  .   vxorpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: [0,2]     .D=eeE-R  .   vblendpd	$2, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: [1,0]     .DeeeeeER .   vaddpd	%ymm0, %ymm0, %ymm1
# CHECK-NEXT: [1,1]     . DeeE--R .   vxorpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: [1,2]     . D==eeER .   vblendpd	$2, %ymm1, %ymm2, %ymm3
# CHECK-NEXT: [2,0]     .  DeeeeeER   vaddpd	%ymm0, %ymm0, %ymm1
# CHECK-NEXT: [2,1]     .  D=eeE--R   vxorpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: [2,2]     .   D==eeER   vblendpd	$2, %ymm1, %ymm2, %ymm3

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     1.0    1.0    0.0       vaddpd	%ymm0, %ymm0, %ymm1
# CHECK-NEXT: 1.     3     1.3    1.3    2.3       vxorpd	%ymm1, %ymm1, %ymm1
# CHECK-NEXT: 2.     3     2.7    0.0    0.3       vblendpd	$2, %ymm1, %ymm2, %ymm3
# CHECK-NEXT:        3     1.7    0.8    0.9       <total>

# CHECK:      [2] Code Region - ZERO-IDIOM-3

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      200
# CHECK-NEXT: Total Cycles:      107
# CHECK-NEXT: Total uOps:        400

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    3.74
# CHECK-NEXT: IPC:               1.87
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      5     1.00                        vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  2      2     1.00                        vandnps	%ymm2, %ymm2, %ymm3

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00   1.00   1.00    -      -     1.00    -     1.00   1.00    -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00    -      -      -      -     1.00    -      -      -      -      -      -      -      -     vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00   1.00    -      -      -      -     1.00   1.00    -      -      -      -      -     vandnps	%ymm2, %ymm2, %ymm3

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeER .   vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: [0,1]     DeeE---R .   vandnps	%ymm2, %ymm2, %ymm3
# CHECK-NEXT: [1,0]     .DeeeeeER.   vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: [1,1]     .DeeE---R.   vandnps	%ymm2, %ymm2, %ymm3
# CHECK-NEXT: [2,0]     . DeeeeeER   vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: [2,1]     . DeeE---R   vandnps	%ymm2, %ymm2, %ymm3

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     1.0    1.0    0.0       vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: 1.     3     1.0    1.0    3.0       vandnps	%ymm2, %ymm2, %ymm3
# CHECK-NEXT:        3     1.0    1.0    1.5       <total>

# CHECK:      [3] Code Region - ZERO-IDIOM-4

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      200
# CHECK-NEXT: Total Cycles:      107
# CHECK-NEXT: Total uOps:        400

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    3.74
# CHECK-NEXT: IPC:               1.87
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      5     1.00                        vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  2      2     1.00                        vandnps	%ymm2, %ymm2, %ymm3

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00   1.00   1.00    -      -     1.00    -     1.00   1.00    -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -     1.00   1.00    -      -      -      -     1.00    -      -      -      -      -      -      -      -     vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -     1.00   1.00    -      -      -      -     1.00   1.00    -      -      -      -      -     vandnps	%ymm2, %ymm2, %ymm3

# CHECK:      Timeline view:
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeER .   vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: [0,1]     DeeE---R .   vandnps	%ymm2, %ymm2, %ymm3
# CHECK-NEXT: [1,0]     .DeeeeeER.   vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: [1,1]     .DeeE---R.   vandnps	%ymm2, %ymm2, %ymm3
# CHECK-NEXT: [2,0]     . DeeeeeER   vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: [2,1]     . DeeE---R   vandnps	%ymm2, %ymm2, %ymm3

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     1.0    1.0    0.0       vaddps	%ymm0, %ymm1, %ymm2
# CHECK-NEXT: 1.     3     1.0    1.0    3.0       vandnps	%ymm2, %ymm2, %ymm3
# CHECK-NEXT:        3     1.0    1.0    1.5       <total>

# CHECK:      [4] Code Region - ZERO-IDIOM-5

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      200
# CHECK-NEXT: Total Cycles:      903
# CHECK-NEXT: Total uOps:        1000

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    1.11
# CHECK-NEXT: IPC:               0.22
# CHECK-NEXT: Block RThroughput: 4.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  8      4     3.00                        vperm2f128	$136, %ymm0, %ymm0, %ymm1
# CHECK-NEXT:  2      5     1.00                        vaddps	%ymm1, %ymm1, %ymm0

# CHECK:      Resources:
# CHECK-NEXT: [0.0] - PdAGLU01
# CHECK-NEXT: [0.1] - PdAGLU01
# CHECK-NEXT: [1]   - PdBranch
# CHECK-NEXT: [2]   - PdCount
# CHECK-NEXT: [3]   - PdDiv
# CHECK-NEXT: [4]   - PdEX0
# CHECK-NEXT: [5]   - PdEX1
# CHECK-NEXT: [6]   - PdFPCVT
# CHECK-NEXT: [7.0] - PdFPFMA
# CHECK-NEXT: [7.1] - PdFPFMA
# CHECK-NEXT: [8.0] - PdFPMAL
# CHECK-NEXT: [8.1] - PdFPMAL
# CHECK-NEXT: [9]   - PdFPMMA
# CHECK-NEXT: [10]  - PdFPSTO
# CHECK-NEXT: [11]  - PdFPU0
# CHECK-NEXT: [12]  - PdFPU1
# CHECK-NEXT: [13]  - PdFPU2
# CHECK-NEXT: [14]  - PdFPU3
# CHECK-NEXT: [15]  - PdFPXBR
# CHECK-NEXT: [16.0] - PdLoad
# CHECK-NEXT: [16.1] - PdLoad
# CHECK-NEXT: [17]  - PdMul
# CHECK-NEXT: [18]  - PdStore

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]
# CHECK-NEXT:  -      -      -      -      -      -      -      -     2.00   6.00    -      -      -      -     1.00   1.00    -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0.0]  [0.1]  [1]    [2]    [3]    [4]    [5]    [6]    [7.0]  [7.1]  [8.0]  [8.1]  [9]    [10]   [11]   [12]   [13]   [14]   [15]   [16.0] [16.1] [17]   [18]   Instructions:
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -     6.00    -      -      -      -      -     1.00    -      -      -      -      -      -      -     vperm2f128	$136, %ymm0, %ymm0, %ymm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -     2.00    -      -      -      -      -     1.00    -      -      -      -      -      -      -      -     vaddps	%ymm1, %ymm1, %ymm0

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          0123456789

# CHECK:      [0,0]     DeeeeER   .    .    .    .   .   vperm2f128	$136, %ymm0, %ymm0, %ymm1
# CHECK-NEXT: [0,1]     . D==eeeeeER   .    .    .   .   vaddps	%ymm1, %ymm1, %ymm0
# CHECK-NEXT: [1,0]     .  D======eeeeER    .    .   .   vperm2f128	$136, %ymm0, %ymm0, %ymm1
# CHECK-NEXT: [1,1]     .    D========eeeeeER    .   .   vaddps	%ymm1, %ymm1, %ymm0
# CHECK-NEXT: [2,0]     .    .D============eeeeER.   .   vperm2f128	$136, %ymm0, %ymm0, %ymm1
# CHECK-NEXT: [2,1]     .    .  D==============eeeeeER   vaddps	%ymm1, %ymm1, %ymm0

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     7.0    0.3    0.0       vperm2f128	$136, %ymm0, %ymm0, %ymm1
# CHECK-NEXT: 1.     3     9.0    0.0    0.0       vaddps	%ymm1, %ymm1, %ymm0
# CHECK-NEXT:        3     8.0    0.2    0.0       <total>