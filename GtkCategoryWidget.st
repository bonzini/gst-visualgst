GtkListWidget subclass: GtkCategoryWidget [
 
    GtkCategoryWidget class >> on: aClass [
	<category: 'instance creation'>
 
	^ (self new)
	    initialize;
	    classOrMeta: aClass;
	    yourself
    ]
 
    classOrMeta [
	<category: 'accessing'>
    
	^ self model classOrMeta
    ]
 
    classOrMeta: aClass [
	<category: 'accessing'>
 
	self model classOrMeta: aClass
    ]
 
    model [
	<category: 'accessing'>
 
	^ model ifNil: [ model := GtkCategoryModel new ]
    ]

    title [
        <category: 'accessing'>

        ^ 'Categories'
    ]

    viewedItems [
        <category: 'accessing'>

        ^ #('text')
    ]
 
    buildPopupMenu [
	<category: 'popup event'>
 
	^ (GTK.GtkMenu new)
	    appendMenuItems: {{'Add a category'. self. #newCategory}.
	    {'Rename a category'. self. #renameCategory}.
	    {'Delete a category'. self. #deleteCategory}.
	    {}.
	    {'File out a category'. self. #fileoutCategory}};
	    yourself
    ]
 
    selection [
	<category: 'selection'>
 
	^ super selection first
    ]
 
    newCategory [
        <category: 'category events'>
 
        AddCategoryCommand on: self
    ]
 
    renameCategory [
        <category: 'category events'>
 
        RenameCategoryCommand on: self
    ]
 
    deleteCategory [
        <category: 'category events'>
 
        DeleteCategoryCommand on: self
    ]
 
    fileoutCategory [
        <category: 'category events'>
 
        FileoutCategoryCommand on: self classOrMeta categorized: self selectedCategory
    ]
]

