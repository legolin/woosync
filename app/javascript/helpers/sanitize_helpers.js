import sanitizeHtml from "sanitize-html";

/** Remove all HTML from input text, while still displaying all the markup */
export const sanitizeText = (input) => {
  return sanitizeHtml(input, {
    allowedTags: [],
    allowedAttributes: {},
    disallowedTagsMode: 'recursiveEscape'
  });
}

/**
 * Allow only a strict subset of HTML for formatting purposes.
 * No images, scripts or links are allowed.
 */
export const sanitizeWithFormatting = (input) => {
  return sanitizeHtml(input, {
    allowedTags: ["b", "i", "em", "strong", "u", "strike", "br", "p", "ul", "ol", "li"],
    allowedAttributes: {},
  });
}
