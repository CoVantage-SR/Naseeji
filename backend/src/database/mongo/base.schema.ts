import { Schema, SchemaOptions } from 'mongoose';

export const baseSchemaOptions: SchemaOptions = {
  timestamps: true,
  toJSON: {
    virtuals: true,
    transform: (_doc, ret) => {
      delete ret.__v;
      return ret;
    },
  },
  toObject: {
    virtuals: true,
    transform: (_doc, ret) => {
      delete ret.__v;
      return ret;
    },
  },
};

export const applySoftDeletePlugin = (schema: Schema): void => {
  schema.add({
    deletedAt: { type: Date, default: null },
    isDeleted: { type: Boolean, default: false, index: true },
  });
};
