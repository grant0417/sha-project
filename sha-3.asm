.data
rounds:
    .word 24

rotl: # ROTL64(x, y) (((x) << (y)) | ((x) >> (64 - (y))))
    addi x1, 24