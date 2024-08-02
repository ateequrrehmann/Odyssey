import "package:flutter/material.dart";

import "odyssey_game.dart";
import "game_ui_button.dart";
import "ui_constants.dart";

class ShopMenu extends StatefulWidget {
  const ShopMenu({super.key, required this.game});

  final OdysseyGame game;

  @override
  State<ShopMenu> createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            const SizedBox(height: 24.0),
            GameUIButton(
              buttonLabel: "Back",
              labelFontSize: UIConstants.menuButtonTextFontSize,
              callback: () {
                widget.game.overlays.remove("ShopMenu");
                widget.game.overlays.add("MainMenu");
              },
              width: MediaQuery.of(context).size.width,
              height: 50,
            ),
            const SizedBox(height: 24.0),
            MoneyCard(money: widget.game.creditsCollected),
            const SizedBox(height: 24.0),
            ShopItemsList(game: widget.game),
            const SizedBox(height: 24.0),
            GameUIButton(
              buttonLabel: "Back",
              labelFontSize: UIConstants.menuButtonTextFontSize,
              callback: () {
                widget.game.overlays.remove("ShopMenu");
                widget.game.overlays.add("MainMenu");
              },
              width: MediaQuery.of(context).size.width,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class MoneyCard extends StatefulWidget {
  const MoneyCard({super.key, required this.money});

  final int money;

  @override
  State<MoneyCard> createState() => _MoneyCardState();
}

class _MoneyCardState extends State<MoneyCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Text(
        "\$ ${widget.money}",
        style: const TextStyle(
          color: UIConstants.whiteTextColor,
          fontSize: 24.0,
        ),
      ),
    );
  }
}

class ShopItem extends StatelessWidget {
  const ShopItem({
    super.key,
    required this.icon,
    required this.image,
    required this.itemPrice,
    required this.unlockAction,
    required this.isUnlocked,
    required this.level,
  });

  final IconData icon;
  final String image;
  final int itemPrice;
  final VoidCallback unlockAction;
  final bool isUnlocked;
  final int level;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                icon,
                color: UIConstants.whiteTextColor,
                size: 40.0,
              ),
              title: Column(
                children: [
                  Text(
                    'Level $level',
                    style: const TextStyle(
                      color: UIConstants.whiteTextColor,
                      fontSize: 16.0,
                    ),
                  ),
                  isUnlocked
                      ? Image.asset(
                    image.replaceFirst('.png', '.png'),
                    height: 100.0,
                    width: 100.0,
                  )
                      : Image.asset(
                    image,
                    height: 100.0,
                    width: 100.0,
                  ),

                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "\$ $itemPrice",
                  style: const TextStyle(
                    color: UIConstants.whiteTextColor,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(width: 20),
                GameUIButton(
                  buttonLabel: isUnlocked ? "unlocked" : "unlock",
                  labelFontSize: isUnlocked ? (level == 4 ? 14.0 : 16.0) : 16.0, // Conditionally adjust font size
                  callback: unlockAction,
                  width: 120,
                  height: 40,
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}




class ShopItemsList extends StatefulWidget {
  const ShopItemsList({super.key, required this.game});

  final OdysseyGame game;

  @override
  State<ShopItemsList> createState() => _ShopItemsListState();
}

class _ShopItemsListState extends State<ShopItemsList> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          if (!widget.game.unlockedItems.contains('shield1'))
            ShopItem(
              icon: Icons.shield,
              image: 'assets/images/shield1.png',
              itemPrice: 600,
              isUnlocked: widget.game.unlockedItems.contains('shield1'),
              unlockAction: () {
                if (widget.game.creditsCollected < 600) {
                  widget.game.overlays.add("NotEnoughCreditsPopUp");
                  return;
                }
                widget.game.unlockedItems.add('shield1');
                widget.game.creditsCollected -= 600;
                widget.game.overlays.add("UnlockedPopUp");
                widget.game.shieldCapacityIPowerUp=true;
                widget.game.updateUserInfo(widget.game.userId);
                setState(() {});
              },
              level: 1,
            ),
          if (widget.game.unlockedItems.contains('shield1') && !widget.game.unlockedItems.contains('shield2'))
            ShopItem(
              icon: Icons.shield,
              image: 'assets/images/shield2.png',
              itemPrice: 1000,
              isUnlocked: widget.game.unlockedItems.contains('shield2'),
              unlockAction: () {
                if (widget.game.creditsCollected < 1000) {
                  widget.game.overlays.add("NotEnoughCreditsPopUp");
                  return;
                }
                widget.game.unlockedItems.add('shield2');
                widget.game.creditsCollected -= 1000;
                widget.game.overlays.add("UnlockedPopUp");

                widget.game.shieldCapacityIIPowerUp=true;
                widget.game.updateUserInfo(widget.game.userId);
                setState(() {});
              },
              level: 2,
            ),
          if (widget.game.unlockedItems.contains('shield2') && !widget.game.unlockedItems.contains('shield3'))
            ShopItem(
              icon: Icons.shield,
              image: 'assets/images/shield3.png',
              itemPrice: 1400,
              isUnlocked: widget.game.unlockedItems.contains('shield3'),
              unlockAction: () {
                if (widget.game.creditsCollected < 1400) {
                  widget.game.overlays.add("NotEnoughCreditsPopUp");
                  return;
                }
                widget.game.unlockedItems.add('shield3');
                widget.game.creditsCollected -= 1400;
                widget.game.overlays.add("UnlockedPopUp");

                widget.game.shieldCapacityIIIPowerUp=true;
                widget.game.updateUserInfo(widget.game.userId);
                setState(() {});
              },
              level: 3,
            ),
          if (widget.game.unlockedItems.contains('shield3') && !widget.game.unlockedItems.contains('shield4'))
            ShopItem(
              icon: Icons.shield,
              image: 'assets/images/shield4.png',
              itemPrice: 2000,
              isUnlocked: widget.game.unlockedItems.contains('shield4'),
              unlockAction: () {
                if (widget.game.creditsCollected < 2000) {
                  widget.game.overlays.add("NotEnoughCreditsPopUp");
                  return;
                }
                widget.game.unlockedItems.add('shield4');
                widget.game.creditsCollected -= 2000;
                widget.game.overlays.add("UnlockedPopUp");

                widget.game.shieldCapacityIVPowerUp=true;
                widget.game.updateUserInfo(widget.game.userId);
                setState(() {});
              },
              level: 4,
            ),
          if (widget.game.unlockedItems.contains('shield4') && !widget.game.unlockedItems.contains('shield5'))
            ShopItem(
              icon: Icons.shield,
              image: 'assets/images/shield5.png',
              itemPrice: 2400,
              isUnlocked: widget.game.unlockedItems.contains('shield5'),
              unlockAction: () {
                if (widget.game.creditsCollected < 2400) {
                  widget.game.overlays.add("NotEnoughCreditsPopUp");
                  return;
                }
                widget.game.unlockedItems.add('shield5');
                widget.game.creditsCollected -= 2400;
                widget.game.overlays.add("UnlockedPopUp");

                widget.game.shieldCapacityVPowerUp=true;
                widget.game.updateUserInfo(widget.game.userId);
                setState(() {});
              },
              level: 5,
            ),
          if (widget.game.unlockedItems.contains('shield5') && !widget.game.unlockedItems.contains('shield6'))
            ShopItem(
              icon: Icons.shield,
              image: 'assets/images/shield6.png',
              itemPrice: 3000,
              isUnlocked: widget.game.unlockedItems.contains('shield6'),
              unlockAction: () {
                if (widget.game.creditsCollected < 3000) {
                  widget.game.overlays.add("NotEnoughCreditsPopUp");
                  return;
                }
                widget.game.unlockedItems.add('shield6');
                widget.game.creditsCollected -= 3000;
                widget.game.overlays.add("UnlockedPopUp");

                widget.game.shieldCapacityVIPowerUp=true;
                widget.game.updateUserInfo(widget.game.userId);
                setState(() {});
              },
              level: 6,
            ),
          if (widget.game.unlockedItems.contains('shield1') && widget.game.unlockedItems.contains('shield2') && widget.game.unlockedItems.contains('shield3') && widget.game.unlockedItems.contains('shield4')&& widget.game.unlockedItems.contains('shield5')&& widget.game.unlockedItems.contains('shield6'))
            ShopItem(
              icon: Icons.shield,
              image: 'assets/images/shield6.png',
              itemPrice: 0,
              isUnlocked: widget.game.unlockedItems.contains('shield6'),
              unlockAction: () {
                setState(() {});
              },
              level: 4,
            ),
          // Add more ShopItem instances as needed with appropriate icons and images
          ShopItem(
            icon: Icons.healing,
            image: 'assets/images/heal.png',
            itemPrice: 4000,
            isUnlocked: widget.game.unlockedItems.contains('heal'),
            unlockAction: () {
              if (widget.game.creditsCollected < 4000 || widget.game.unlockedItems.contains('heal')) {
                if (widget.game.creditsCollected < 4000) {
                  widget.game.overlays.add("NotEnoughCreditsPopUp");
                  return;
                }
                widget.game.overlays.add("AlreadyUnlockedPopUp");
                return;
              }
              widget.game.unlockedItems.add('heal');
              widget.game.creditsCollected -= 4000;
              widget.game.overlays.add("UnlockedPopUp");
              widget.game.healPowerUp=true;
              widget.game.updateUserInfo(widget.game.userId);
              setState(() {});
            },
            level: 1,
          ),
          ShopItem(
            icon: Icons.whatshot,
            image: 'assets/images/shoot1.png',
            itemPrice: 3500,
            isUnlocked: widget.game.unlockedItems.contains('shoot1'),
            unlockAction: () {
              if (widget.game.creditsCollected < 3500 || widget.game.unlockedItems.contains('shoot1')) {
                if (widget.game.creditsCollected < 3500) {
                  widget.game.overlays.add("NotEnoughCreditsPopUp");
                  return;
                }
                widget.game.overlays.add("AlreadyUnlockedPopUp");
                return;
              }
              widget.game.unlockedItems.add('shoot1');
              widget.game.creditsCollected -= 3500;
              widget.game.overlays.add("UnlockedPopUp");
              widget.game.fireRateIPowerUp=true;
              widget.game.updateUserInfo(widget.game.userId);
              setState(() {});
            },
            level: 1,
          ),
          if(widget.game.unlockedItems.contains('shoot1') && !widget.game.unlockedItems.contains('shoot2'))
          ShopItem(
            icon: Icons.healing,
            image: 'assets/images/shoot2.png',
            itemPrice: 4000,
            isUnlocked: widget.game.unlockedItems.contains('shoot2'),
            unlockAction: () {
              if (widget.game.creditsCollected < 4000 || widget.game.unlockedItems.contains('shoot2')) {
                if (widget.game.creditsCollected < 4000) {
                  widget.game.overlays.add("NotEnoughCreditsPopUp");
                  return;
                }
                widget.game.overlays.add("AlreadyUnlockedPopUp");
                return;
              }
              widget.game.unlockedItems.add('shoot2');
              widget.game.creditsCollected -= 4000;
              widget.game.overlays.add("UnlockedPopUp");
              widget.game.fireRateIIPowerUp=true;
              widget.game.updateUserInfo(widget.game.userId);
              setState(() {});
            },
            level: 2,
          ),

          ShopItem(
            icon: Icons.military_tech,
            image: 'assets/images/machine_gun_collectable.png',
            itemPrice: 6000,
            isUnlocked: widget.game.unlockedItems.contains('machine_gun'),
            unlockAction: () {
              if (widget.game.creditsCollected < 6000 || widget.game.unlockedItems.contains('machine_gun')) {
                if (widget.game.creditsCollected < 6000) {
                  widget.game.overlays.add("NotEnoughCreditsPopUp");
                  return;
                }
                widget.game.overlays.add("AlreadyUnlockedPopUp");
                return;
              }
              widget.game.unlockedItems.add('machine_gun');
              widget.game.creditsCollected -= 6000;
              widget.game.overlays.add("UnlockedPopUp");
              widget.game.machineGunPowerUp=true;
              widget.game.updateUserInfo(widget.game.userId);
              setState(() {});
            },
            level: 1,
          ),
        ],
      ),
    );
  }
}




