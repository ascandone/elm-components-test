module.exports = {
  content: ["./src/**/*.{html,elm}"],
   theme: {
      fontFamily: {
        sans: ["inter", "sans-serif"],
        mono: ["Fira Code", "monospace"]
      },
      extend: {
        boxShadow: {
          soft: "0 4px 42px rgba(0, 0, 0, 0.15)",
        },
        transitionTimingFunction: {
            custom: 'cubic-bezier(0.4,0,0.46,1.66)',
        }
      }
  },
  plugins: [],
}
