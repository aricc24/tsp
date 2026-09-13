
type Matrix* = object
    data*: seq[float]
    n*: int

proc newMatrix*(n: int): Matrix =
    Matrix(data: newSeq[float](n * n), n: n)

proc `[]`*(m: Matrix, i, j: int): float {.inline.} =
    m.data[i * m.n + j]

proc `[]=`*(m: var Matrix, i, j: int, value: float) {.inline.} =
    m.data[i * m.n + j] = value

proc toMatrix*(rows: seq[seq[float]]): Matrix =
    let n = rows.len
    result = newMatrix(n)
    for i in 0 ..< n:
        for j in 0 ..< n:
            result[i, j] = rows[i][j]