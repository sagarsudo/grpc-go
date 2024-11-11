#!/bin/bash

# --- Configurable Variables ---

# Server address
server_address="$BENCHMARK_URL"

# Test cases with weights
test_case="long_server_streaming"
test_cases="${test_case}:100"

# Minimum number of stubs per channel
min_stubs=1
# Maximum number of stubs per channel
max_stubs=1

# Minimum number of channels per server
min_channels=1
# Maximum number of channels per server
max_channels=1

# Test duration in seconds
test_duration=10

# --- End of Configurable Variables ---

# Output file for results
output_file="grpc_benchmark_results_${test_case}.csv"

# Create header row in the output file
echo "num_stubs_per_channel,num_channels_per_server,total_calls_made" > "$output_file"

# Loop through all values of num_stubs_per_channel from 1 to max_stubs
for stubs in $(seq "$min_stubs" "$max_stubs"); do
  # Loop through all values of num_channels_per_server from 1 to max_channels
  for channels in $(seq "$min_channels" "$max_channels"); do
    # Run the client with the current parameters
    result=$(./client \
      --server_addresses="$server_address" \
      --test_cases="$test_cases" \
      --use_alts=true \
      --test_duration_secs="$test_duration" \
      --num_stubs_per_channel="$stubs" \
      --num_channels_per_server="$channels")

    # Extract the total calls made from the result
    total_calls=$(echo "$result" | grep "Total calls made:" | awk '{print $4}')

    # Append the results to the output file
    echo "$stubs,$channels,$total_calls" >> "$output_file"
  done
done

echo "Benchmark complete. Results written to $output_file"

