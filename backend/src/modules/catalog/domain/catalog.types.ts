export type CategoryStatus = 'active' | 'inactive' | 'archived';
export type BrandStatus = 'active' | 'inactive' | 'archived';

export type ProductType = 'physical' | 'made_to_order' | 'custom' | 'service';

export type ProductStatus =
  | 'draft'
  | 'pending_review'
  | 'active'
  | 'inactive'
  | 'rejected'
  | 'archived'
  | 'out_of_stock';

export type ProductVisibility = 'public' | 'private' | 'hidden';

export type MediaType = 'image' | 'video' | 'document';

export interface ProductSpecification {
  key: string;
  value: string;
}

export interface CatalogMediaConfig {
  maxImageSizeMb: number;
  maxVideoSizeMb: number;
  maxDocumentSizeMb: number;
  maxVideoDurationSeconds: number;
}
