// Instance the tour
tour = new Tour();

// Add your steps. Not too many, you don't really want to get your users sleepy
tour.addSteps([
  {
    element: ".container a",
    title: "Welcome to the Rails Girls Workshop Manamement App",
    content: "Learn about the functionality of this app in just a few steps!"
  }
]);

// Initialize the tour
tour.init();

// Start the tour
tour.start();