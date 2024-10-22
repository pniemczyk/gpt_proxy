const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/components/**/*.rb',
    './app/components/**/*.{erb,haml,html,slim}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  safelist: [
    {
      pattern: /text-(red|green|blue|yellow|gray|indigo|purple|pink|orange|amber|teal|cyan)-[0-9]{3}/,
    },
    {
      pattern: /bg-(red|green|blue|yellow|gray|indigo|purple|pink|orange|amber|teal|cyan)-[0-9]{2,3}/,
    },
    {
      pattern: /border-(red|green|blue|yellow|gray|indigo|purple|pink|orange|amber|teal|cyan)-[0-9]{2,3}/,
    }
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
