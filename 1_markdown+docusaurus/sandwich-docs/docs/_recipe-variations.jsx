export default function RecipeVariations({ preference }) {
    const recipes = {
      standard: (
        <>
          <h3>Classic Club Sandwich</h3>
          <ol>
            <li>Toast 3 slices of bread</li>
            <li>Layer 1: Mayonnaise, lettuce, sliced turkey</li>
            <li>Layer 2: Bacon, tomato, avocado</li>
            <li>Stack and slice diagonally</li>
          </ol>
        </>
      ),
      vegetarian: (
        <>
          <h3>Garden Veggie Delight</h3>
          <ol>
            <li>Toast 2 slices of whole grain bread</li>
            <li>Spread with hummus</li>
            <li>Layer: Cucumber, avocado, sprouts</li>
            <li>Top with tomato and lettuce</li>
          </ol>
        </>
      )
    };
  
    return recipes[preference] || recipes.standard;
  }