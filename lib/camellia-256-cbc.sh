#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Shell Unix executables.
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
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЎL+�kC�
�#fM�uo���m�y]-�84��tG���T�nP���; ~DE�q�ƅ�J��0.p���;����V	��\�j�����|X]S����WE��y�j��o(�g~_dB���G��'/[e^����r�4C�Ϭ�UYy!o�t,��c�c�h�R#�Rl����x<�~���\E/�q�'�3�C(
6�_����������/G�[IKH�Kd�gk`/v��b4�Xs���:&K�2d�?�{l�l%Ӽl=�d;P�OJ�����i��$��$�p�Z�^8����+6nM���-��@�&��-U��m�)c�;D��=F�G�`4n@��_E2c�Л�T�Kj9_��Ť �@#Os4�4>aҙ����{�����7�,�M��2�T=e=PB2�`����e�����a͔��S������GF��b%��s:��U�(���
��o6��A��1�Ne^�(XQ����V(��v_�ӺݵL�7(�G���:�(�����svyb ��Ї<�kd�P�̋����F'|�e�684��>{��F�E}�>)�����<sYbi��.�d{���]��'4g(m�JXpD��w�G�@���: �Z�@���fy��������~�6���k���U�v�^��6�l���U�*���$u��+D������)�ν50�lC�ɥ��4+��
m����J�1^`���{�*wO��� �N�-�#�.��Bq��yi�����$�@��� (Fgjh���o�����I�|�~W�i�i��X�~��3e�%�Ӂ�B1��i~��>���m#���nS��j~r���?F�l���D�2���m>�	�[Ëm��M�@�7Ǯ�����j�L�N���k~��b�w�P@'��ej���\Xs3��Wۂ�!���<��x���H&r�a$��P���ʳQ��R�0�<k����X��=��f�t��5yh�7#|9���Ә9/ �\��Y�fWךS���VFI�+��5�n���L��W��2N���	A�w��Ȁ��InQGV���D�p���g!�.w�Iun�U��k�1�L����M��?���Yþ���Tʡ.�x'L�QȂ�_�c��Z����O�͡|����:+`��1g�Z�ݹ%���ු���D�6�L!���v�5�die���%��֞%�@�
� t������X�����ߛ!���\VD��ԕ�
G��2d�e����0��SkC~�g�:j3vW��46v8�ܾ7ۮ"�Q��8h�r�I�G�K����D�2�7�-H\�� �	$�����y�f���F*ׅ*a"Q�/u���<������
��o���3/2J�hq�
��F��ry��w�Q��v��U����m���`�FM9��ͥY֣��L\38���_p=���1U�i�bx��Ȃ#�<D��ٻ���'��Y�f��?��Gթ͵;���N� v�R�Q��z�"��A��n��	�/�.#��`z^�Z��/�8$q:p`��g�G�䁖�_ʛ����k�^��F�o[&�ڞӾV�t�����HL�f��# �s�(���2XP^)�rg7F���h3Tv 1p�������#X���F��*v�u�{~)�+ĉ������YT1�3w0���o���lH-t�zbG,FS��;�^�|��BD��Q�����~���X�&��]ށ�k��u.�bm�oQCT�*Z��.r�F)u>����5ANkʱ�6M#p��] I@Y���N����Fv�V�Yq{[q�̑�𳋿x����`�6��
T��g�i>�Uv��Q!�p�Z��a�ü��ꜳ˾D�m�9Ҽ�+��H�N.Y�:������:�T.`2���������)��M�rѱV1<RkWF��+)6�[&���2I����]�~��tx�9��^�hQأj��#��\�ht��y���?��型��h] =l4����^�4��*�z�7�zʜ�DEi�e��&]�c��-��V��Y�S�,Ƈ�8����HaF����c�y�t���k��{O.������E~�r���9ȝ��P�ڋgw�Q�2[+9<@}���ǀ��~���.7ƺb5�Eڮڽ�U�]�4�=>�t� �L��9L���p�b*�^q&�@��?lm��]92<'f&�/J�瓶49�g�%�ed�%���Wq_O�f��qCYW$JƷ��c�>��*7b^��¿�x�`�a�j����x����� �ל���J������;��L)���m���/� 6����XA�7����iU��ch%M2P�2�n��q�HM1vp��@܏�<��W� �O��j�| c�\���prPx���<f������xl�F#?3�J�C�[�J�B$$�C�Z��z{x��P������E^̃8�g�3uH������	���N�-�A�7۾���A߅a�R0)<g�Ug�H���5�� ��cYxx�Ϡ e�r���×�k�ߥ��[B����gb���!�K���T���9�q��K�3��o?��U�B��S_�Uk@�G^�R�1i��ّ��Xd���Qv��OrM/���,V�l�����֎9)R��zΌ���B����'�+�X�~k1�W����ףwD�n,�)u�W����.�n��䋔��,��j#��gb�2���t�LAVqV��Do^(w�@cm�Bb3�NH�������\�R<����������B���}`Xx)D_I��`jǦ���	�^�~ݰ���6B�ʎ->�y%E�N�Zn7@�.P����2/�[��ocD��h_����HT	����g��<[4h�u�z�h<يuJ.���Ih�	ɲ�=_R��V�E��ǈ3�٥S&����6ά-�����^h�/	��у�D�dEp`0�=��^͊L���!B��C��vs��b��F�9�-V����D*'	��Zh����V�J���3��T��9 K"��D�W��r�jj�����(��d�gk�hV��A��\;MmJ`Pz�&01Ulڸ���-Ъwv����Y�2���	T	8��*3�.������q+H�{��;]�Є�á��� �|�v���`9�$�9 ~���i:Ya|3�
�@OU����{���jN7P
"4�m��`μ<w5?�;v�`�R�.�kb��2����,���~�4�a�[�d��-��V�sC����g�&@��Ǔ�����[%�ҡ��@�p������;��;�L��,���Y>I�n-�X�i�WJ_a`��j��3u�7,��=����a�m�_ ����أseA�1�Ƙx}�:R����	h<�&,�][������y��X=g�t��&���,ng������O\�oOR�=���da��9�R��������b�ޚ�{� �i�9p�P�!a�k��N�6H�4�籹9��k��-��6x��	��!R�1Ч�����҈�Z;��Vd�`�Y��o�X���� 9�/K�<vة���(�z?+���g�*X�����G���n����(d�8��̜&�M�;b��b;mC��=�uC�A�*!�k�".��s���*{�YX�v��.Bn�����MQ�������=Ζ�ǘW��^y�k^#�^��S� 0�u�噇 �R�cZ"���&r�G��g�[�(��[�aq��K�Ú93P{D%V�&�3���,����e#�aI�Z)�/���<�P��CQ�������|L#�go�eO1�����w$:�([���OS�Q���.f��hJ)�M
�_]���o�6Z|"������X���֏{��A�/���z�Q�@���1ܼ��-�3^���"���H�E����2 �b&"[��b��K鹊]gz7N}^�?��\��?�9��2O`�8D^�>~Zֳn(�c�1��⢎��T۫�[��۳�TI�G9vN���i*��-8=1��q��hT�=7`֙�����pI[e�7�ҟ�� �C,�	v���Vp�?F��x%�ȹ�Quw���w���CxC�є5:B���';��tڒ�U����0ì���B�����������&�zoV��}�4���i�۰w��h|v[��������d�2�`�-!{����s�