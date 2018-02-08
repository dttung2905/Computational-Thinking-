# p1q2.rb *** OPTIONAL ***

# Name: <Fill up>
# Section: <Fill up>

# Takes in:
#   - no of rows of a standard box
#   - no of columns of a standard box
#   - 2D array of items' dimensions
#   e.g. pack(3, 5, [[1, 1], [2, 1], [3, 5], [1, 3], [3, 3]]) 
#
# Returns:
#   - proposed layout of items in all the boxes in this format: 
#     [box0, box1, box2...], where
#     boxX = [[item ID, r1, c1, r2, c2], [item ID, r1, c1, r2, c2]...]
#   e.g. [[[2, 0, 0, 2, 4]],                             <-- box 0
#         [[4, 0, 0, 2, 2],[0, 0, 3, 0, 3]],             <-- box 1
#         [[1, 0, 0, 0, 1],[3, 0, 2, 0, 4]]]             <-- box 2

def pack(box_no_of_rows, box_no_of_col, items)
  # TODO: replace the whole method

  # hard coded "correct" solution for test case in dataA.csv
  # test case: [[1, 3], [10, 2], [3, 10], [7, 10], [7, 1], [1, 5], [8, 9], [7, 3]]
  box0 = [[1, 0, 0, 9, 1], [0, 2, 2, 2, 4]]
  box1 = [[2, 0, 0, 2, 9]]
  box2 = [[3, 0, 0, 6, 9]]
  box3 = [[4, 0, 0, 6, 0]]
  box4 = [[5, 0, 0, 0, 4]]
  box5 = [[6, 0, 0, 7, 8]]
  box6 = [[7, 0, 0, 6, 2]]
  return [box0, box1, box2, box3, box4, box5, box6]
end