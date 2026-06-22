#!/usr/bin/env bats
# Tests for errorz

ERRORZ="${BATS_TEST_DIRNAME}/../errorz"

@test "--api shows 200 OK" {
  run "$ERRORZ" --api
  [ "$status" -eq 0 ]
  [[ "$output" == *200* ]]
  [[ "$output" == *OK* ]]
}

@test "--api shows 404 and 500" {
  run "$ERRORZ" --api
  [[ "$output" == *404* ]]
  [[ "$output" == *500* ]]
}

@test "--api shows the 4xx group header" {
  run "$ERRORZ" --api
  [[ "$output" == *4xx* ]]
}

@test "no args lists categories and exits 0" {
  run "$ERRORZ"
  [ "$status" -eq 0 ]
  [[ "$output" == *api* ]]
}

@test "--help exits 0" {
  run "$ERRORZ" --help
  [ "$status" -eq 0 ]
}

@test "unknown flag exits 1 and prints Unknown" {
  run "$ERRORZ" --bogus
  [ "$status" -eq 1 ]
  [[ "$output" == *Unknown* ]]
}

@test "lookup 404 finds Not Found tagged api, exits 0" {
  run "$ERRORZ" 404
  [ "$status" -eq 0 ]
  [[ "$output" == *"Not Found"* ]]
  [[ "$output" == *api* ]]
}

@test "lookup miss exits 1 with No match" {
  run "$ERRORZ" 999
  [ "$status" -eq 1 ]
  [[ "$output" == *"No match"* ]]
}
