module.exports = ({ env }) => ({
  auth: {
    secret: env('ADMIN_JWT_SECRET', '4d01d03f12ce83193e6596b0245ad425'),
  },
});
