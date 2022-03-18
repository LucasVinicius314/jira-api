import * as dotenv from 'dotenv'

import { DataTypes, Sequelize } from 'sequelize'

import { Entities } from '../typescript/user'

dotenv.config()

const databaseUrl = process.env.DATABASE_URL

export const sequelize = new Sequelize(databaseUrl, {
  dialect: 'postgres',
  ssl: false,
})

const baseAttributes = {
  id: {
    primaryKey: true,
    type: DataTypes.INTEGER,
    autoIncrement: true,
  },
  createdAt: {
    type: DataTypes.DATE,
  },
  updatedAt: {
    type: DataTypes.DATE,
  },
}

const User = sequelize.define<Entities.Common.UserInstance>('user', {
  ...baseAttributes,
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  password: {
    type: DataTypes.STRING(256),
    allowNull: false,
  },
  username: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
})

User.prototype.toJSON = function () {
  let values = Object.assign({}, this.get())
  delete values.password

  return values
}

export const DBEntities = {
  User,
}
