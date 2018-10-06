import java.util.*;

public class AnimationFactory {
    private int index = -1;
    private ArrayList<AnimationInterface> animations = new ArrayList<AnimationInterface>();

    public AnimationFactory() {
        animations.add(new SimpleShadowAnimation());
        //animations.add(new SimpleInvertedAnimation());
        //animations.add(new RainbowAnimation());
    }

    public AnimationInterface getNextAnimation() {
        index = index < animations.size() - 1 ? ++index : 0;
        return animations.get(index);
    }
}