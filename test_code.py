def calculate_sum(a, b):
    result = a + b
    return result


def calculate_sum_again(x, y):
    total = x + y
    return total


def find_maximum(numbers):
    if len(numbers) == 0:
        return None
    max_val = numbers[0]
    for num in numbers:
        if num > max_val:
            max_val = num
    return max_val


def process_data(data_list):
    results = []
    for item in data_list:
        if item > 0:
            results.append(item * 2)
        else:
            results.append(item)
    return results


def main():
    x = 5
    y = 10
    sum = calculate_sum(x, y)
    sum2 = calculate_sum_again(x, y)
    print("Sum is: " + str(sum))
    print("Sum again: " + str(sum2))

    nums = [1, 5, 2, 8, 3]
    max_num = find_maximum(nums)
    print("Max number: " + str(max_num))

    data = [1, -2, 3, -4, 5]
    processed = process_data(data)
    print("Processed data: " + str(processed))


if __name__ == "__main__":
    main()

# Final test of webhook functionality
