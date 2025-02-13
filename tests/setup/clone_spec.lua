local Path = require("plenary.path")
local Job = require("plenary.job")

local multi_build_example = Path:new("multiple-build-file-example/")
local mill_minimal = Path:new("mill-minimal/")
local scala_cli = Path:new("minimal-scala-cli-test/")

-- Not really a test at all, but we run this as a spec so it's picked up during
-- make test-setup and clones the expected repos down before we make test
local clone = function(repo)
  Job
    :new({
      command = "git",
      args = { "clone", repo },
      on_exit = function(_, status)
        if not status == 0 then
          print("Something went wrong cloning")
        else
          print("Correctly cloned")
        end
      end,
      on_start = function()
        print("starting to clone " .. repo)
      end,
    })
    :start()
end

if not (multi_build_example:exists()) then
  clone("https://github.com/ckipp01/multiple-build-file-example.git")
end

if not (mill_minimal:exists()) then
  clone("https://github.com/ckipp01/mill-minimal.git")
end

if not (scala_cli:exists()) then
  clone("https://github.com/ckipp01/minimal-scala-cli-test.git")
end

-- what exactly is this? honestly I don't know, but if we do the repeat 500
-- times, that should be more than enough to clone these down, so if we
-- hit that fail.
local count = 0
while not (multi_build_example:exists()) or not (mill_minimal:exists()) or not (scala_cli:exists()) do
  if count == 500 then
    print("Something went wrong when trying to clone.")
    return
  end
  count = count + 1
  print("waiting for clones to finish...")
end
