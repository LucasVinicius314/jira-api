import * as dotenv from 'dotenv'

import { DataTypes, Sequelize } from 'sequelize'

import { CommonEntities } from '../typescript/user'

dotenv.config()

const databaseUrl = process.env.DATABASE_URL

export const sequelize = new Sequelize(databaseUrl, {
  dialect: 'postgres',
  ssl: true,
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false,
    },
  },
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

const User = sequelize.define<CommonEntities.UserInstance>('user', {
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
  projectKey: {
    type: DataTypes.STRING(256),
    allowNull: false,
  },
  teamKey: {
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

const ApiKey = sequelize.define<CommonEntities.ApiKeyInstance>('api_key', {
  ...baseAttributes,
  key: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    unique: true,
  },
})

// User -> ApiKey

User.hasMany(ApiKey, { foreignKey: 'userId' })
ApiKey.belongsTo(User, { foreignKey: 'userId' })

export const DBEntities = {
  User,
  ApiKey,
}
