# TodoList App

This TodoList app consists of two classes, a `Todo` class and a `TodoList` class.

The `Todo` class takes one required argument, a String `title`, and two optional arguments, a String `description` and a Date `due_date`.

The `TodoList` class takes one required argument, a String `title`.

Example code with output:

```ruby
require 'stamp'
require 'todolist'

todo1 = Todo.new('Do Laundry', "Wash, Dry, and Fold", Date.today)
todo2 = Todo.new("Go to gym", "Leg Day", Date.today + 1)
todo3 = Todo.new("Make Dinner", "Fish and Fried Rice", Date.today)

todo_list = TodoList.new("Today's Todos")
puts todo_list
#---- Today's Todos ----
#[ ] Do Laundry (Due: Friday November 4)
#[ ] Go to gym (Due: Friday November 5)
#[ ] Make Dinner (Due: Thursday November 4)

todo_list.mark_done_at(1)
#---- Today's Todos ----
#[ ] Do Laundry (Due: Friday November 5)
#[X] Go to gym (Due: Friday November 5)
#[ ] Make Dinner (Due: Thursday November 4)

todo_list.mark_all_done
puts todo_list
#---- Today's Todos ----
#[X] Do Laundry (Due: Friday November 5)
#[X] Go to gym (Due: Friday November 5)
#[X] Make Dinner (Due: Thursday November 4)

todo_list.clear
puts todo_list
#---- Today's Todos ----
```

And the necessary Gemfile:
```ruby
gem 'todolist_app'
gem 'stamp'
```