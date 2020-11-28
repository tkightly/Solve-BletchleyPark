# Solve-BletchleyPark

Bletchley Park is a codebreaking challenge that gives the solver a 6x6 matrix, where each character 0-9 and a-z is represented.

Each code comes with a clue and a code. 

Numerical codes require the solver to locate a spare N spaces in each cardinal direction, where N is the value of numerical value of the clue.

Directional codes require the solver to locate each square 1..5 spares in the given direction.

X codes require the solver to locate the square which exists in the corresponding location when the matrix is folded along the horizontal and vertical centers.

The solver must then decide which resulting output is the correct

This code seeks to automate this tedious task.

Tim Kightly