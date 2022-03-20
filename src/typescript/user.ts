import { Model, Optional } from 'sequelize'

export namespace CommonEntities {
  export type UserAttributes = {
    email: string
    password: string
    username: string
    projectKey: string
    teamKey: string

    id: number
    updatedAt: Date
    createdAt: Date
  }

  export type UserCreationAttributes = Optional<
    UserAttributes,
    'createdAt' | 'id' | 'updatedAt'
  >

  export type UserInstance = Model<UserAttributes, UserCreationAttributes> &
    UserAttributes

  export type ApiKeyAttributes = {
    key: string
    userId: number

    id: number
    updatedAt: Date
    createdAt: Date
  }

  export type ApiKeyCreationAttributes = Optional<
    ApiKeyAttributes,
    'createdAt' | 'id' | 'updatedAt'
  >

  export type ApiKeyInstance = Model<
    ApiKeyAttributes,
    ApiKeyCreationAttributes
  > &
    ApiKeyAttributes
}
