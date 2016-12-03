# Tic Tac Toe Game

import math
import numpy

board = [[0 for x in range(3)] for y in range(3)] # 0 is empty, 1 is x, 2 is o

print(numpy.matrix(board))

xLocation = input('Enter location of first x (1 to 9, top left corner to bottom right corner): ') 

if xLocation is 1:
    print("x")
    if board[0][0] is 0:
        board[0][0] = 1
elif xLocation is 2:
    if board[0][1] is 0:
        board[0][1] = 1
elif xLocation is 3:
    if board[0][2] is 0:
        board[0][2] = 1
elif xLocation is 4:
    if board[1][0] is 0:
        board[1][0] = 1
elif xLocation is 5:
    if board[1][1] is 0:
        board[1][1] = 1
elif xLocation is 6:
    if board[1][2] is 0:
        board[1][2] = 1
elif xLocation is 7:
    if board[2][0] is 0:
        board[2][0] = 1
elif xLocation is 8:
    if board[2][1] is 0:
        board[2][1] = 1
elif xLocation is 9:
    if board[2][2] is 0:
        board[2][2] = 1

print(numpy.matrix(board))

moves = 0

while moves != 5:
    if moves is 0:
        if board[1][1] is 0:
            board[1][1] = 2
        else:
            board[0][0] = 2
        moves += 1
    print(numpy.matrix(board))
    moves += 1
        

#if board[0][0] is 1:
#   board[1][1] = 2
