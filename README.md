# functional_gol
A repository of experimental implementations of Conway's Game of Life, mostly in Ruby.

## Implementations

### `hybrid`

Implementing the Game of Life with Functional Objects and dependency injection. The code turned out pretty clean, I think.

`bundle install && bundle exec ruby ./src/hybrid/game_of_life.rb`


### `pipeline`

A (bad) attempt at writing Haskell in Ruby. There's a reverse-composition operator, `.>>` based on `dry-pipeline`. It turns out, Ruby doesn't want to be Haskell and the Game of Life doesn't compose very well.

`ruby ./src/pipeline/game_of_life.rb`
