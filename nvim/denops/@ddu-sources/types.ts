// https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification

type DocumentUri = string;

/**
 * Defines an unsigned integer number in the range of 0 to 2^31 - 1.
 */
export type uinteger = number;

export interface LocationLink {
  /**
   * Span of the origin of this link.
   *
   * Used as the underlined span for mouse interaction. Defaults to the word
   * range at the mouse position.
   */
  originSelectionRange?: Range;

  /**
   * The target resource identifier of this link.
   */
  targetUri: DocumentUri;

  /**
   * The full target range of this link. If the target for example is a symbol
   * then target range is the range enclosing this symbol not including
   * leading/trailing whitespace but everything else like comments. This
   * information is typically used to highlight the range in the editor.
   */
  targetRange: Range;

  /**
   * The range that should be selected and revealed when this link is being
   * followed, e.g the name of a function. Must be contained by the
   * `targetRange`. See also `DocumentSymbol#range`
   */
  targetSelectionRange: Range;
}

interface Range {
  /**
   * The range's start position.
   */
  start: Position;

  /**
   * The range's end position.
   */
  end: Position;
}

interface Position {
  /**
   * Line position in a document (zero-based).
   */
  line: uinteger;

  /**
   * Character offset on a line in a document (zero-based). The meaning of this
   * offset is determined by the negotiated `PositionEncodingKind`.
   *
   * If the character value is greater than the line length it defaults back
   * to the line length.
   */
  character: uinteger;
}
