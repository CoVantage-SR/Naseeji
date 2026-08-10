export class SlugUtil {
  public static slugify(text: string): string {
    return text
      .toString()
      .toLowerCase()
      .trim()
      .replace(/\s+/g, '-') // Replace spaces with -
      .replace(/[^\w-]+/g, '') // Remove all non-word chars
      .replace(/--+/g, '-') // Replace multiple - with single -
      .replace(/^-+/, '') // Trim - from start of text
      .replace(/-+$/, ''); // Trim - from end of text
  }

  public static async generateUniqueSlug(
    baseName: string,
    existsFn: (slug: string) => Promise<boolean>,
  ): Promise<string> {
    const rawSlug = this.slugify(baseName) || 'supplier-store';
    let currentSlug = rawSlug;
    let counter = 1;

    while (await existsFn(currentSlug)) {
      counter++;
      currentSlug = `${rawSlug}-${counter}`;
    }

    return currentSlug;
  }
}
