from random import randrange, shuffle, randint
import time
from copy import deepcopy

board = [
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
]
temp = [
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
    [".", ".", ".", ".", ".", ".", ".", ".", "."],
]


def checkGrid(grid):
    for r in range(9):
        for c in range(9):
            if grid[r][c] == ".":
                return False
    return True


def isValid(board, r, c, d):
    #print("analasying: " + str(d) + " on row: " + str(r) + " and on col: " +
    # str(c))
    for row in range(9):
        if board[row][c] == d:
            return False

    for col in range(9):
        if board[r][col] == d:
            return False

    for row in range((r // 3) * 3, (r // 3 + 1) * 3):
        for col in range((c // 3) * 3, (c // 3 + 1) * 3):
            if board[row][col] == d:
                return False

    #print("Got a valid")
    return True


def solve(board):
    for r in range(9):
        for c in range(9):
            if board[r][c] == '.':
                for d in range(1, 10):
                    if isValid(board, r, c, d):
                        board[r][c] = d
                        if (solve(board)):
                            return True
                        else:
                            board[r][c] = '.'
                return False
    return True


def removeElements(board):
    global counter
    for r in range(9):
        for c in range(9):
            if board[r][c] == '.':
                for d in range(1, 10):
                    if isValid(board, r, c, d):
                        board[r][c] = d
                        if checkGrid(board):
                            counter += 1
                            break
                        elif (removeElements(board)):
                            return True
                        else:
                            board[r][c] = '.'
                return False
    return True


def solveSudoku(board):
    solve(board)


def fillGrid(grid):
    numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    for r in range(9):
        for c in range(9):
            if board[r][c] == '.':
                shuffle(numberList)
                for d in numberList:
                    if isValid(board, r, c, d):
                        board[r][c] = d
                        if (fillGrid(board)):
                            return True
                        else:
                            board[r][c] = '.'
                return False
    return True


fillGrid(board)
print("Random Solved Sudoku")
print(board)

attempts = 1
counter = 1
while attempts > 0:
    r = randint(0, 8)
    c = randint(0, 8)
    while board[r][c] == ".":
        r = randint(0, 8)
        c = randint(0, 8)
    backup = board[r][c]
    board[r][c] = "."
    boardCopy = []
    for row in range(0, 9):
        boardCopy.append([])
        for col in range(0, 9):
            boardCopy[row].append(board[row][col])

    counter = 0
    removeElements(boardCopy)
    # print("Counter: " + str(counter))
    # print("Atempts left " + str(attempts))
    if counter != 1:
        board[r][c] = backup
        attempts -= 1
    # print("Counter: " + str(counter))
    # print("Atempts left " + str(attempts))

newBoard = []
for row in range(0, 9):
    newBoard.append([])
    for col in range(0, 9):
        newBoard[row].append(board[row][col])

print("Random Elements Removed")
print(newBoard)
solve(newBoard)
print("The same sudoku, without elements, but solved")
print(newBoard)