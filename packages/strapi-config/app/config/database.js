module.exports = ({ env }) => ({
  connection: {
    client: 'postgres',
    connection: {
      host: env('DATABASE_HOST', 'postgres'),
      port: env.int('DATABASE_PORT', 5432),
      database: env('DATABASE_NAME', 'strapi'),
      user: env('DATABASE_USERNAME', 'seanaye'),
      password: env('DATABASE_PASSWORD', 'cf4bc0069e74b7321470262bca7b731b'),
      ssl: env.bool('DATABASE_SSL', false),
    },
  },
});
