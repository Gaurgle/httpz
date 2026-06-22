#!/usr/bin/env bats
# Tests for httpz

HTTPZ="${BATS_TEST_DIRNAME}/../httpz"

@test "prints common codes and exits 0" {
  run "$HTTPZ"
  [ "$status" -eq 0 ]
  [[ "$output" == *200* ]]
  [[ "$output" == *OK* ]]
  [[ "$output" == *404* ]]
  [[ "$output" == *500* ]]
}

@test "shows all four group headers" {
  run "$HTTPZ"
  [[ "$output" == *2xx* ]]
  [[ "$output" == *3xx* ]]
  [[ "$output" == *4xx* ]]
  [[ "$output" == *5xx* ]]
}

@test "includes the expanded codes" {
  run "$HTTPZ"
  [[ "$output" == *410* ]]
  [[ "$output" == *418* ]]
  [[ "$output" == *451* ]]
  [[ "$output" == *501* ]]
}

@test "-h prints usage and exits 0" {
  run "$HTTPZ" -h
  [ "$status" -eq 0 ]
  [[ "$output" == *Usage* ]]
}

@test "rejects unexpected arguments" {
  run "$HTTPZ" --bogus
  [ "$status" -eq 1 ]
}
