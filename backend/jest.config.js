/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src', '<rootDir>/tests'],
  moduleNameMapper: {
    '^@config/(.*)\\.js$': '<rootDir>/src/config/$1',
    '^@core/(.*)\\.js$': '<rootDir>/src/core/$1',
    '^@bootstrap/(.*)\\.js$': '<rootDir>/src/bootstrap/$1',
    '^@database/(.*)\\.js$': '<rootDir>/src/database/$1',
    '^@infrastructure/(.*)\\.js$': '<rootDir>/src/infrastructure/$1',
    '^@middleware/(.*)\\.js$': '<rootDir>/src/middleware/$1',
    '^@modules/(.*)\\.js$': '<rootDir>/src/modules/$1',
    '^@routes/(.*)\\.js$': '<rootDir>/src/routes/$1',
    '^@shared/(.*)\\.js$': '<rootDir>/src/shared/$1',
    '^@types/(.*)\\.js$': '<rootDir>/src/types/$1',
    '^@utils/(.*)\\.js$': '<rootDir>/src/utils/$1',
    '^(\\.\\.?/.*)\\.js$': '$1',
  },
  setupFilesAfterEnv: ['<rootDir>/tests/setup.ts'],
  testMatch: ['**/*.spec.ts', '**/*.test.ts'],
  coverageDirectory: 'coverage',
  collectCoverageFrom: ['src/**/*.ts', '!src/**/*.d.ts', '!src/server.ts'],
};
