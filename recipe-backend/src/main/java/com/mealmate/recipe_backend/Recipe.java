package com.mealmate.recipe_backend;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Recipe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;

    public String title;
    public int minutes;
    public String category;
    public String imageUrl;
    public boolean favorite;
    public Boolean builtIn = false;

    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "recipe_id")
    public List<Ingredient> ingredients = new ArrayList<>();

    @ElementCollection
    public List<String> steps = new ArrayList<>();
}