import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { ICategoryDocument } from '../../infrastructure/database/category.schema.js';

export interface CategoryTreeNode extends ICategoryDocument {
  children: CategoryTreeNode[];
}

export class ListCategoriesUseCase {
  constructor(private categoryRepo: CategoryRepository) {}

  public async execute(
    filters: Record<string, any> = {},
    page = 1,
    limit = 50,
  ): Promise<{ items: ICategoryDocument[]; total: number }> {
    return this.categoryRepo.list(filters, page, limit);
  }

  public async getTree(): Promise<CategoryTreeNode[]> {
    const rawCategories = await this.categoryRepo.getTree();
    const activeCategories = rawCategories.filter((c) => c.status === 'active');

    const map = new Map<string, CategoryTreeNode>();
    const roots: CategoryTreeNode[] = [];

    activeCategories.forEach((cat) => {
      map.set(cat._id, { ...cat, children: [] });
    });

    activeCategories.forEach((cat) => {
      const node = map.get(cat._id)!;
      if (cat.parentId && map.has(cat.parentId)) {
        map.get(cat.parentId)!.children.push(node);
      } else {
        roots.push(node);
      }
    });

    return roots;
  }
}
