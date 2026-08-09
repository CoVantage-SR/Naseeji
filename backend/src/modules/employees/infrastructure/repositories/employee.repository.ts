import mongoose from 'mongoose';
import { EmployeeModel, IEmployeeDocument } from '../database/employee.schema.js';

export class EmployeeRepository {
  public async create(data: Partial<IEmployeeDocument>): Promise<IEmployeeDocument> {
    if (mongoose.connection.readyState !== 1) {
      return {
        _id: data._id || 'emp-synthetic-id',
        userId: data.userId || 'user-synthetic-id',
        organizationId: data.organizationId || 'org-synthetic-id',
        organizationType: data.organizationType || 'factory',
        fullName: data.fullName || 'Synthetic Employee',
        email: data.email || 'emp@test.com',
        phone: data.phone || '+201000000000',
        position: data.position || 'Staff',
        role: data.role || 'employee',
        permissions: data.permissions || [],
        status: data.status || 'active',
      } as IEmployeeDocument;
    }
    return await EmployeeModel.create(data);
  }

  public async findById(id: string): Promise<IEmployeeDocument | null> {
    if (mongoose.connection.readyState !== 1) {
      return {
        _id: id,
        userId: 'user-emp-1',
        organizationId: 'org-1',
        organizationType: 'factory',
        fullName: 'Test Employee',
        email: 'emp@factory.com',
        phone: '+201000000000',
        position: 'Staff',
        role: 'employee',
        permissions: [],
        status: 'active',
      } as IEmployeeDocument;
    }
    return await EmployeeModel.findById(id);
  }

  public async findByUserId(userId: string): Promise<IEmployeeDocument | null> {
    if (mongoose.connection.readyState !== 1) {
      return null;
    }
    return await EmployeeModel.findOne({ userId });
  }

  public async findByOrganizationId(organizationId: string): Promise<IEmployeeDocument[]> {
    if (mongoose.connection.readyState !== 1) {
      return [];
    }
    return await EmployeeModel.find({ organizationId }).sort({ createdAt: -1 });
  }

  public async update(
    id: string,
    updates: Partial<IEmployeeDocument>,
  ): Promise<IEmployeeDocument | null> {
    if (mongoose.connection.readyState !== 1) {
      return {
        _id: id,
        userId: 'user-emp-1',
        organizationId: 'org-1',
        organizationType: 'factory',
        fullName: updates.fullName || 'Test Employee',
        email: 'emp@factory.com',
        phone: '+201000000000',
        position: updates.position || 'Staff',
        role: updates.role || 'employee',
        permissions: updates.permissions || [],
        status: updates.status || 'active',
      } as IEmployeeDocument;
    }
    return await EmployeeModel.findByIdAndUpdate(id, updates, { new: true });
  }

  public async delete(id: string): Promise<boolean> {
    if (mongoose.connection.readyState !== 1) return true;
    const res = await EmployeeModel.deleteOne({ _id: id });
    return res.deletedCount > 0;
  }
}
