struct node {
  int x;
  struct node *next;
};

int main()
{
    /* This won't change, or we would lose the list in memory */
    struct node *root;       
    /* This will point to each node as it traverses the list */
    struct node *conductor;  
    root = malloc( sizeof(struct node) );
    root->next = 0;   
    root->x = 12;
    conductor = root; 
    if ( conductor != 0 ) {
        while ( conductor->next != 0)
        {
            conductor = conductor->next;
        }
    }
    conductor = conductor->next; 

    if ( conductor == 0 )
    {
        return 0;
    }
    /* initialize the new memory */
    conductor->next = 0;         
    conductor->x = 42;

    return 0;
}
