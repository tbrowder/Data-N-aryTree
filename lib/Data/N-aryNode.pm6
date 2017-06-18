unit class N-aryNode;

# Based on the TreeNode class at:
#   http://rosettacode.org/wiki/Tree_traversal#Perl_6
#
# Which is copied to this directory as 'Tree-traversal-Perl-6.p6'
class N-aryNode {
    has N-aryNode $.parent;
    has N-aryNode @.siblings;
    has $.value;

    method pre-order {
        flat gather {
            take $.value;
            take @.siblings.pre-order if @.siblings;
        }
    }

    method in-order {
        flat gather {
            take $.value;
            take @.siblings.in-order if @.siblings;
        }
    }

    method post-order {
        flat gather {
            take @.siblings.post-order if @.siblings;
            take $.value;
        }
    }

    method level-order {
        my N-aryNode @queue = (self);
        flat gather while @queue.elems {
            my $n = @queue.shift;
            take $n.value;
            @queue.push($n.left) if $n.left;
            @queue.push($n.right) if $n.right;
        }
    }
}

=begin pod
my N-aryNode $root .= new( value => 1,
                    left => N-aryNode.new( value => 2,
                            left => N-aryNode.new( value => 4, left => N-aryNode.new(value => 7)),
                            right => N-aryNode.new( value => 5)
                    ),
                    right => N-aryNode.new( value => 3,
                             left => N-aryNode.new( value => 6,
                                     left => N-aryNode.new(value => 8),
                                     right => N-aryNode.new(value => 9)
                                     )
                             )
                    );

say "preorder:  ",$root.pre-order.join(" ");
say "inorder:   ",$root.in-order.join(" ");
say "postorder: ",$root.post-order.join(" ");
say "levelorder:",$root.level-order.join(" ");
=end pod
