# Website

This website is built using [Docusaurus](https://docusaurus.io/), a modern static website generator.

### Installation

```bash
npm install
```

### Local Development

```
$ npm start
```

This command starts a local development server and opens up a browser window. Most changes are reflected live without having to restart the server.

### Build

```
$ npm run build
```

This command generates static content into the `build` directory and can be served using any static contents hosting service.

### Single-sourcing with Docusaurus

This project demonstrates how to single-source content using Docusaurus. The main content files are located in the `docs` directory, and you can see examples of how to import and reuse components across different markdown files.

For example, in `docs/standard_sandwich.mdx`, we import and use components like this:

```mdx
import SafetyNotice from './_safety-notice.md'
import RecipeVariations from './_recipe-variations'
...
<SafetyNotice/>
...
<RecipeVariations preference="standard" />
...
<RecipeVariations preference="vegetarian" />
```

`<SafetyNotice/>` and `<RecipeVariations/>` are reusable components defined in separate markdown files. `<SafetyNotice/>` contains a static safety notice about food handling, while `<RecipeVariations/>` is a component that takes a `preference` prop to render different sandwich recipes based on the user's choice.

This allows us to maintain consistency and reduce redundancy in our documentation.