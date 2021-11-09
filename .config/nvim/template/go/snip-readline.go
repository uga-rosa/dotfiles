func readlines(filename string) []string {
	file, err := os.Open(filename)
	check(err)
	scanner := bufio.NewScanner(file)
	lines := make([]string, 0)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines
}
