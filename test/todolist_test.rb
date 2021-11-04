require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/reporters'
require 'date'
require_relative '../lib/todolist'

Minitest::Reporters.use!

class TodoListTest < Minitest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(@list.size, @todos.size)
  end

  def test_first
    assert_equal(@list.first, @todos.first)
  end

  def test_last
    assert_equal(@list.last, @todos.last)
  end

  def test_shift
    assert_equal(@list.shift, @todos.first)
    assert_equal(@list.size, @todos.size - 1)
  end

  def test_pop
    assert_equal(@list.pop, @todos.last)
    assert_equal(@list.size, @todos.size - 1)
  end

  def test_done_question
    assert_equal(false, @list.done?)
    @list.done!
    assert_equal(true, @list.done?)
  end

  def test_add_raise_error
    assert_raises(TypeError) { @list.add(1) }
    assert_raises(TypeError) { @list.add("Hello") }
  end

  def test_shovel_operator
    assert_equal(@list.size, @todos.size)
    @list << Todo.new('Do dishes')
    assert_equal(@list.size, @todos.size + 1)
  end

  def test_add_alias
    assert_equal(@list.size, @todos.size)
    @list.add Todo.new('Do dishes')
    assert_equal(@list.size, @todos.size + 1)
  end

  def test_item_at
    assert_equal(@list.item_at(0), @todos.first)
    assert_equal(@list.item_at(2), @todos.last)
    assert_raises(IndexError) { @list.item_at(3) }
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(3) }
    assert_raises(IndexError) { @list.mark_done_at(100) }

    @list.mark_done_at(0)
    assert(@todos.first.done?)
    @list.mark_done_at(1)
    assert(@todos[1].done?)
  end

  def test_mark_undone_at
    @list.done!
    assert_equal(@todos.first.done?, true)

    @list.mark_undone_at(0)
    assert_equal(@todos.first.done?, false)
  end

  def test_done_bang
    assert_equal(@todos[0].done?, false)
    assert_equal(@todos[1].done?, false)
    assert_equal(@todos[2].done?, false)
    @list.done!
    assert(@todos[0].done?)
    assert(@todos[1].done?)
    assert(@todos[2].done?)
    assert(@list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(100) }

    assert_equal(3, @list.size)
    @list.remove_at(1)
    assert_equal([@todos[0], @todos[2]], @list.to_a)
  end

  def test_to_s
    @todo2.due_date = Date.civil(2021, 11, 6)
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room (Due: Saturday November 6)
    [ ] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_to_s_again
    @list.mark_done_at(0)
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_all_marked
    @list.done!
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT
    assert_equal(output, @list.to_s)
  end

  def test_each
    result = []
    @list.each { |todo| result << todo }
    assert_equal([@todo1, @todo2, @todo3], result)
  end

  def test_each_returns_self
    list = @list.each { |todo| }
    assert_equal(list, @list)
  end

  def test_select
    @todo1.done!
    list = TodoList.new(@list.title)
    list.add(@todo1)

    assert_equal(list.title, @list.title)
    assert_equal(list.to_s, @list.select{ |todo| todo.done? }.to_s)
  end

  def test_all_not_done
    @list.mark_all_done
    assert(@list.done?)
    @list.mark_all_undone
    assert(@list.all_not_done?)
  end

  def test_mark_done_by_title
    @list.mark_done(@todo1.title)
    assert(@list.first.done?)
  end

  def test_mark_all_done
    @list.mark_all_done
    assert(@list.all_done?)
  end

  def test_no_due_date
    assert_nil(@todo1.due_date)
  end

  def test_due_date
    due_date = Date.today + 3
    @todo1.due_date = due_date
    assert_equal(due_date, @todo1.due_date)
  end
end