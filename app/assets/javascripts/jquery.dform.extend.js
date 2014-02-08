$.dform.addType("textarea", function(options) {
    // Return a new button element that has all options that
    // don't have a registered subscriber as attributes
    return $("<textarea>").dform('attr', options);
});