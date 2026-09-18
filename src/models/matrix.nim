#[
Defines a compact square matrix structure backed by a one-dimensional sequence.

This module provides matrix creation, indexed access, element assignment,
and conversion from a sequence of rows into the matrix representation.
]#

type Matrix* = object
    data*: seq[float]
    n*: int

#[
Creates a new square matrix of size n x n.
]#
proc newMatrix*(n: int): Matrix =
    Matrix(data: newSeq[float](n * n), n: n)

#[
Returns the value stored at the specified row and column.
]#
proc `[]`*(m: Matrix, i, j: int): float {.inline.} =
    m.data[i * m.n + j]

#[
Stores a value at the specified row and column.
]#
proc `[]=`*(m: var Matrix, i, j: int, value: float) {.inline.} =
    m.data[i * m.n + j] = value

#[
Converts a sequence of rows into the compact matrix representation.
]#
proc toMatrix*(rows: seq[seq[float]]): Matrix =
    let n = rows.len
    result = newMatrix(n)
    for i in 0 ..< n:
        for j in 0 ..< n:
            result[i, j] = rows[i][j]