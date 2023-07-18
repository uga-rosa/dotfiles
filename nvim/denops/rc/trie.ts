class TrieNode {
  readonly children: Record<string, TrieNode>;
  endOfWord: boolean;

  constructor() {
    this.children = {};
    this.endOfWord = false;
  }
}

export default class Trie {
  readonly root: TrieNode;

  constructor() {
    this.root = new TrieNode();
  }

  insert(word: string): void {
    let current = this.root;
    for (let i = 0; i < word.length; i++) {
      const ch = word.charAt(i);
      const node = current.children[ch] ?? new TrieNode();
      current.children[ch] = node;
      current = node;
    }
    current.endOfWord = true;
  }

  private searchPrefix(
    node: TrieNode,
    prefix: string,
    wordList: string[],
  ): void {
    if (node.endOfWord) {
      wordList.push(prefix);
    }
    for (const ch in node.children) {
      this.searchPrefix(node.children[ch], prefix + ch, wordList);
    }
  }

  search(prefix: string): string[] {
    let node = this.root;
    for (let i = 0; i < prefix.length; i++) {
      node = node.children[prefix.charAt(i)];
      if (node === undefined) {
        return [];
      }
    }
    const wordList: string[] = [];
    this.searchPrefix(node, prefix, wordList);
    return wordList;
  }
}
