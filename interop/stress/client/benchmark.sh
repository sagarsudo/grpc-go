#!/bin/bash

# --- Configurable Variables ---

# Server address
server_address="$BENCHMARK_URL"

# Test cases with weights
test_case="long_server_streaming"
test_cases="${test_case}:100"

# Test duration in seconds
test_duration=100

# --- End of Configurable Variables ---

# Output file for results
output_file="grpc_benchmark_results_${test_case}.csv"

# Create header row in the output file
echo "total_calls_made" > "$output_file"

response_sizes=(100000 1000000 10000000 100000000 1000000000)

# Loop through all values of num_stubs_per_channel from 1 to max_stubs
for i in "${!response_sizes[@]}"; do
  response_size="${response_sizes[$i]}"
  result=$(./client \
    --server_addresses="$server_address" \
    --test_cases="$test_cases" \
    --use_alts=true \
    --test_duration_secs="$test_duration" \
    --num_stubs_per_channel=1\
    --num_channels_per_server=1 \
    --response_size="$response_size")
    # Extract the total calls made from the result
    total_calls=$(echo "$result" | grep "Total calls made:" | awk '{print $4}')

    # Append the results to the output file
    echo "$total_calls" >> "$output_file"
done

echo "Benchmark complete. Results written to $output_file"

