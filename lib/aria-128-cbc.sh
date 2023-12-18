#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Unix executables with openssl enc.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}o�����=5PX� !������x*1�&t6�F�N쁸��e?��*XTy�p>�a}3��irS��mfL�L�1�=��d��X�{���Y�8$�1�t҆ �%"������I�
�"�/(��(�L�_B���e�h��tz�|�+U
�p1�b�?���>��!!(7l8�|�0��In�a�����J�<;��C�ڽ|�b���ϊ���7�(�e�w�|ˬg!YX��J"��t0�T���Q�	�F�M¬��"g?�g~R�M�!��#.oc8�2��R3�a20��߮�w��{\k_8�ǛE�B�ܟ�BZ�;5��Wb�n����7�kO1��rK���R�4��ӣ��XL*����=�g���̣YC�\�ۜ��"90����>��g��j�]��ש�x+�\��Ǆ�	�;}�{�|��~�L�ѵ��(|M���'I<ΕRK)T�������}jY��C2a��)ؓOs�J���{D�P��$5;
�ʨ5��!��E��Uo�x��ҷ��4�G�*O\g���`���id��a�>q���ٳ��t��!�����Z�-� �zg��{=U][!���%�+��<oj�wm<a0���<F����`�ܐ�A����(!���cx�J��~�M3��d��?2�Q�(�y�B,,t�/�[��s���F�l���]T	�j�%%O������3�� ����G���vP���dK:BJ�~|�^"ʡ>7v�����c�3�L@�EkJ�n�1��5��ǟ����1س�����X�U��q.�a�i��.۬l��4����-�L�ʡD�s�WΛ���a��$����L���=�PIj��v;׼��F	�L/ȡ�#q���Mn<���!�Klx�Ǉ�8����U$T{y;4�Y�}���f-�(!�l'P�2iD����d�ʤ�`>����9�*a�"C�l�P3�!�Jbb��.�����?�����L'gyE63��v
�zht��.*��fWb�s+,ʺ�1��K�V;�^�J0g?}�������N"�A���x�$�!nxMB� U<����:.�z����6NTA�!`�����d�b
��z�'H l�8��r�Z�Ԑh]gݗ���1��gyz��`�r� �d^�]1ݎ^V�d��B 49�S� t��=�D��829 �j���������Tk��Հ�^3I[�[%���lx���Q���ϐ�+�����R��S���>�&���gپ���7w������ED�1i{r�>шsoOJ�82�<]�&5��;qUp�sf-@n�)Ѕ^J�u'<�1������>�Ȯ�[}�]\,���ƹ� ^����L��"E��0?\���S�:/@-Y�O �����nv5�	B ��5�0@P@�\0q'r4�ZO�@qOI���i-�id<}󵃶C3I�8W�k�sR���}`�i:$�%�D�`"�/ȻOk6������db\�$����u� 8�%VW��]�~�gW�ɐ8s�Z4߷�����	f,c�ڗ�9n��9����:c�}���R�����Kѳ8m~�MٸnE�f`�-x�Y�ó]	��{�?h���dbcg�ƅ�������^��Ǩ`�|�)�ZT�
b� 4����S6J�˺��C����*No�''�v/�(���"��#�RE��ȋ�O�c�p��Ϡe�K��i�=)<A��c�S��#��	I:�Z�1���!-�'r?�^f�T�^3#�����΃�J��\���=�K�3Ųg�m�r�3:�2�����6K>*���(<�x�8Ч�ֿ�x��+� �<�r@iåԋdl qr��� nL����ٴ�O��6��Ǜ�-�Onȶ�1)=��[,�g9�%t�uD?n�O�>����0�ٶy��(�����Ǐ�uF����q����Wȭ�4�v�?iTHJ����v���* ���4��{�=#�2�	�~8���6 /]��E򕿥es��W-�)a�e����B��D���|V)�ŝ�ME��r+�Jե�i/.6*9�p\�R��?���(��,�!�]$�y��(K����`Յ���S%�]_(�l=I}�V�<�wȹ�W��t�����G�;����8N����(��O��f�w�"�=��f���*?ZV|��
ɚd��g�(L���-��~<v�6�07���o4�f�n
��i�^�A�*_��Eb��!�*��r��np�`�=O���M]dg����Ѵ��r���%YT!��S�׀��J�*\���e'��r���!;Na��גj>�����-q�U��;�0�<�׀�SO&	�]�b�ޏ���FCl��3���4��"~u��i|F+lֹW.�ydW|�$������ˋȏ�Җ�S����$Ϝ�),l��!�V��{���	���N�lV�ӃeW�n:�������6� �^�kcBCq'��u��4�!���;@Xi���5�E*ww�%���1��ܾ�"0��D����l������E�t{4�խ��P����Z�!�̛�#� �g��9��O>�ӣ����A�g��+U�D���v�8ߚN?��y�+���Z3&�k�w�@m������с�����wo�vC����^ېt����BR'p2"�����o���Ǔ��*���˩;�����kY��k�Q4Uz�ݖ�?S�hRB�CK�'�`�L�O��o�_Kp� J|����J[܅ܑ( ��7CN�i������2�"�'LA��w�BS�SA�QZU�
�+X�� ���l<��T�
�����qMv��0��pȾ�%�d�����s��7t��C8,�~Hz$Dϙ��eJ�W��V�f�E���ū��12����lF`s7Ã����^Ǜ5����X1\�B�ޔQS�8R���P���QR`XjV-Ύ	��*}i�ZK_��;쨣�������߬�� ���_m,ǁ�Ш�=Kh!/����OT8.��B���u���aCY���M"J��UTI�� X��ks(�+�{!C��~�)C2W_��#�����x菓Q�D��k��l@K]�c�8.�	�yq�
H�*�o�9; �#I��]ط���4��/-E\0~�����鯞cK|݆Pc��P���(��0�L�Q4ӆ-��綥�V�='�W�9�0J�,����0��Kj��^��敨gw�fT/	Z�OW���J�W5F���������Cu$$���Kbm�3�[�0Sw@,	�nv�`�������Q�.K�ۓ�k��[�[a�k���?�."k\>-�z@`�L�$(
��.,�/�bM^�����n�T7,R�9�|���^R����T<ex_�:�aI�}�h>0��( �禌�Y����Y��-02���t��V�R΅��Y��Y��ͲI�fb��v�6�v�K��t�P���3L���|�n�Yc�ut9��8�UՀ�>;�0�D�R�����"Ȓ��XX=�8���Ű9��m���g��^^1k��\(=���y� hB%�s	ћB�����18��V�P_�`'+c�ѿ9����Q{�8�A�uh�'+"KĹ-Uiѐn�q��0�q+?����%�櫲�������Ȉ�r�4?k��1/��U�u&�S�.� �_�sn�gX�s���(|A���-I��X�di_]�ǫ�C�H��łqn_��r��lg)b)�VOV�l�ˮ726=DLb1�2Zt̜�}c=wO�ٱ~���_ �U����p�V5P3g�s�X7��m���J�p�������y�0��Ҭ)I�W�*�HF��S����TA�@���C?�B1w�~�.`�+��C(�H���A��A��JcEqx�i�$nϗp
�{���U�!�Ӄ+9y��1��|�ml�����Hd�*�_WQ��j�z~<����-\S���Y�C�����K

�Nԩ��ˈd7���F �