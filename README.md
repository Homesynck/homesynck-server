# HomeSynck server

## How to work on this ?
1. `git clone` in a cozy place on your filesystem
2. Try `mix --version` to make sure everything is installed
3. `cd src` and now you can start jamming!
   - `mix deps.get` to install all dependencies
   - `mix test` to test
   - `mix dialyzer` to run a static analysis (may take some time the first time)
   - `mix compile` to compile
   - `mix app.start` to compile and start the server

## Before pushing
- Run the dialyzer analysis and get rid of all errors and warnings
- Make sure all previously passing tests still pass