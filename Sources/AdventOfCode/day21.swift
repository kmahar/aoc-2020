struct Food {
    let ingredients: [String]
    let allergens: [String]

    init(_ s: Substring) {
        let components = s.components(separatedBy: " (contains ")
        ingredients = components[0].split(separator: " ").map { String($0) }
        allergens = components[1].dropLast().components(separatedBy: ", ")
    }
}

func day21() throws {
    let input = try readLines(forDay: 21)
    let foods = input.map { Food($0) }

    let allergens = Set(foods.map { $0.allergens }.reduce([], +))
    var allergensToIngredients = [String: Set<String>]()

    for allergen in allergens {
        // ingredients for each food that contains the allergen.
        let possibleContainers = foods.filter { $0.allergens.contains(allergen) }.map { Set($0.ingredients) }
        // find ingredients that all possible containers have in common.
        let intersection = possibleContainers[1...].reduce(possibleContainers[0]) { $0.intersection($1) }
        allergensToIngredients[allergen] = intersection
    }

    let ingredientsPossiblyContainingAllergens = allergensToIngredients.values.reduce([], +)

    let appearancesOfNonAllergens = foods.map { food in
        food.ingredients.filter { !ingredientsPossiblyContainingAllergens.contains($0) }.count
    }.reduce(0, +)
    print("Part 1: \(appearancesOfNonAllergens)")

    var finalAllergensToIngredients = [String: String]()
    // loop until we've assigne all allergens to ingredients.
    while finalAllergensToIngredients.count < allergensToIngredients.count {
        // look for any allergens that only map to a single ingredient
        for (allergen, possibleContainers) in allergensToIngredients where possibleContainers.count == 1 {
            let ingredient = possibleContainers.first!
            // finalize the assignment
            finalAllergensToIngredients[allergen] = ingredient
            // remove the ingredient as an option for any other allergen
            for a in allergensToIngredients.keys {
                allergensToIngredients[a]!.remove(ingredient)
            }
        }
    }

    let sortedIngredients = finalAllergensToIngredients.sorted { $0.0 < $1.0 }.map { $0.1 }.joined(separator: ",")
    print("Part 2: \(sortedIngredients)")
}
