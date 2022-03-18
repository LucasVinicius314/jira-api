import { Model, Optional } from 'sequelize'

export namespace Entities.Common {
  export type UserAttributes = {
    email: string
    password: string
    username: string

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
}
