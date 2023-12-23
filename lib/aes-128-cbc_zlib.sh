#!/bin/bash
#
# Author: fatimazq (Fatimah Azzahra)
# GitHub: https://github.com/fatimazq
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
]   �������� �BF=�j�g�z��"�gV�>�5I��k�Z$b~�����؊��$�䡉w|h��P�ރ}9V�WC3�ϋ�֮h�N�E�8�2T/D���F=��[7رm!٘����-f*�z;�p��Ǖ�/a��8�b�Ԉ��0^g&ВN$��F���l~?e�oJd�&�2�7����Yފ�6CJ
�&�i�C��Ot���꺼L��dF���D>6fr�6@J��m�k��WGy�{��+k�`R]�h��d�5G�D�4R�g��VM��Vt94"u_8��J��Ρw��*+�Lo�]�(�\�zG�!C�%m�am	p����S�r(�EOR�*�FQ�������yn~Z����Toˣq�,ﰧg�@���h��u7/ҴF�_8�7���ύ�]XĂ�r=�YM�����VٷHBV�(A9q]�Sk��gK�eS�M�^6K���c[��vlc��ݞ�8ut��~�A����	��Tt�u�.�֬�� ���/[�8��{tS��'[g���b�	6��8N4G�u��jV���	[a�dY�M��j�Cm��~�-_E}!�$g���P,AC��K,u��FЕ��ǃ���r$Twη�\*����R�^j���oBmTg���=�ٜ���5��>~������g�[�-�[j`��8
)��%�A�=�5}EMLs���1��d6�4� �+�4_��-OV8}�=���y��Z1kR��L'k��.��;:2�GV��k�g�=8yF��_�+4���n�[�6��Ȩ�!��pw�](|ًP�]=E,�g��%��(*T����#�_� ��Ɛ��t��"��?ˁ��zx#�r�kԊA%I�7�j�K����SIU�D�DM�=�ߧ���)�܂��\������� �H�O;y�}��8��Rΐ|�c� �pa�!^D�1��0Q�0 N��yX������xl5Kj��P.G9*��)X�06�F&C"�WI;F��l^2L�K���R�;w�V��x �TD�� �ދ�ȸʣֳWX_ /��
;rA/�#̃1AeR�bk#!��j����Y����'R�߂��IDv�S�X8�-����&����P�eAͨ\nzG��# :��ipU�Xڥ/@Fk�C6��x�G�\���X'�����թ���\��oD����$̢�:үޣ����;^�*V]C���
˳��lA�$ƿ#�A��;u�܄�l�z�q�t>��>�Ƶ�?��'� S9�2�Z��r~ &� ����.�ΰa.ߦ�+�ǟ���:�(D&r/7u>k������P*4W}��^�&�pE�x�����A�Y����iFCf�С���K�}F�sN��=�j����!,��Y�u�t�s$���u��Э+�S�<�|�Ѕ�l���_�k�-~�v��?c+��<�L���	�e|����v��ԡ�<��
خ5R��%C���yu�2yB�Lؽ[�c�S^�&��FOd��z}:^���X�;��͓j�c�'�Gv̉�|c�.��11}�8H���s79V.D��\��oq%��HT�+st��ˤ����D�.��:��NB��h/�o�s���҇K���じ�H�Q6�@�`%��A�E+e��Ә�\��}���H.R2���j%��q�t,�WB��?��]����`𓲨O)�F�����>r��2���Q|E	/���swrIsm��S��\D��7���ǽ�x�W�P��"��r��s��l�OEvh���)��g �$)B�D�B���ȍ��uäC���OGP"��zi߾�`�QqdzG��~��S�(�E_�,A�7���u�fHn(#I�ŝhH��m�TLVLs�1d�&6��Q4�ʋ��|,�(�V=��e1\N���yC�d4BHQX��)�Ob���%'�i���K�~r��.�V���'��5�gо2uxN4�&�`w(b�Q
|�)����g��G�Xnc���>ל��G�hԜ����T����`M�t0�Nj��9cp!�f�({�,�+��?Y����̗ X�m��QO���0FZ���d�uM��5c�h�\䡹ܞ	m$=�����MBn� q	]ʕp��(ڏ�A� ��rc19y?X�P�>�R�A�'��J�-�I�?�l����[!ۆ���,��_Q�},Y��"����7'��0�F�53A�Y�Kܤ�m��)�-��/��.����,��,ζ�oY^�h�ŷI@^��T|��,�7'_?>pʚ����2Xv�tX6[.��K)o0���Z���x� (XX�𺴧�w��E9��r��7q��ee[�f)mWĀR����2�xSK�E��7G
8��dTY��w�m�<��4f�9+&"���F�W7��Uҟ"C�|�H�j��|�"]���O����㆜�1�;S㍋6��fom{����������Ij��� �-�IR�g��@�̠e��D�u�}Y������(Uq�#!E�����13k��-��g�%R���fX��R�}��`x?�G�kV s�r�e���a2�['3�a��^���P}2R���'�ePIc��4�>�/\%�	��1Adiv��[7i��ޔ�=y�e��( `I�N�#t�ƅB���)��v�F���6��5��Ia+�����XÈ*<�s�)�'���i�r\rhc��aO����͘$�D�Ex�/,[�X�pঌ8�.��>iu���
��ò��x%^>o�kT����2e�V2Q�(�Z�t�tD�d�z�!୪����-� ��ɴH�<"(>J��G`�H�ќ��1&ǒ��IWȆ�F\ze�Z���[��x��(�>��Z8�[HA��ݝ2rV��c| �+8�/��O��*�� �g�_�s1�ߵ��������}� E�*���S@���/��h8)Vƈx��>g��]���U�&�Z,��;�M=�z���uO�����j�]��)$��4�ᕝ]�\d��H�oj+������1l��IZ	\l�s��˛���a�I�u�oYb�D�?h��a����W�C������\?4��B �-S�U���zme���������5��ϕ|PT�t �Ү��?6�&��u��u�G��C/�;�or�m����"u���2����Ξ�O����W�[jG�-)��(��X���ma��h�O���?w�t'�Y��.-�j��*�l�h�.�:>���k��c?��V+��TJʴ�1��s��i,T��Nݳ�yaCM9��2x�?���l"sv=�I
�F���1ᰳ*����[�Ip0��~���{=�G�Um�a~?�	ٷ�b2�]�xX�ncZgt�`(wYQ'w�\`KP��]��j8?�	�,Tݾ	ԫ�:�]M�Y|g���-�.H�c�V�l�=xZ�6PҬ=�����t�$��>�?���d1��X�6��Q�<n�LLv�aV��F��_c����V!'L7�k��6�#]Ej���j��<��Ù��ʷ���<���s��u^�Ƅf[�?�I��G�xX2��Lx؟��*|������?OG�R�6�ߕc�;9�6 �X���,�çguI&;q10T9fŅ���#K��VM��%Ȣ<M=0�}W�l@���@@��!�rY��E��F�UC�S�<�F��d�e�_����}�g����XM�m'N	�[�]��x+��6t9/MT0���ڶ�,�MD��>F6z���@��u
d�
�����!f�*�h���<��B��^qL,o���~����CfdO_>�2���q�V=q-�]��������&��d�Bq`��Cڢb��6�uZ	�$�&�-��b~`�T�R��t�D�F�@��4�l[�oM������C��c!@�bil�]�fv׋�aM*X�L@����1厀74�hS���?q�T fa�a�,66kt�Sڐ��!���
�@��@����FX>{[Ԅ:F�3�k�Zu��q�X��J�ӻ�X�	�_�«��I�@'7����?*rw8�᠓�A���]���{�K
4�M��(��*m.Q�I8�W��pT��`��b��f�Pda(:^�1iДDU�6�=.�<��,�6d�EZ��m.)�b���/h���������_���1�Ȼ�nOM�v���U��QU���������WFQ\8+PڈLT�lv��WwEa�o�W� F��n�+�JZ����G�}{^D�*`a��4_ā�Q4q��eb�	���{oG�E����C��[��z]�]:,|�2H�C�}�����j��I���4V�/G�!\��L�w%��p`7�%����SXڷ��&�^��rVW��pq�Yg	J��c�S�F�j7��j��:��Ձ)��9Ӫ���� x��0�%��8�K�����@�3X;���B�04���b$���/i���E��a�ӸTO����w�����;�!��h>�Qm��_��#�\�Ԙ�y�GrZ��C���n�0��`���|��+T[jq���~NXAWZ9�]��GK߇8s��^��J���E����&��^�OX;�T�4�y����#}�m���,"c^��ͮ1"���΃�����VC���}����W
�Z.��v�&3Ej	�;�w�.���ˉK�^��K*y	A�rB	��A����W%:����&p�&7[��G᭏E:E�Oc
S����\,d�lqƙ"*}�Z �.$0��:�姪�z�4;��|5&�_�aTh�Í���d�����Ѫ��B����2��G��ӜW��5gE�����|A�;v�Ģ$�����O逬1��or'�����W9WG� �pi{��W�D\X��1����q��;Q����E9i���+���޳�4{�F�SX3~Pny��'s�7��e���?O���*�Y:UV�Q��K������
֞�*PV���-Wnm1�n�Uf�7^��K g�"c��k6 �p���u��`�t�#tB)�MY���A��i'����U���#lt�>��Iu�EW�����5Q���#z��zj��;6=�;bU�ۙ�bg�B�Ɣ8S��//�y�=w3�g�����&�����_�d'3���$EB���|U�oؼ�fd�`p�+�U�ek��a��:�J��o�y<��1JMp�I����;�yuR� rw�]3E��3��ڷ_sȩ��?�f�����y��G�)���D��ЖӢ���4�*T]� �ҥ|��U��7�&���0p
���h>�(x���o,�W�73���zK3#��J3������yu�n7ξQN<��!���K�݉k��	u���`�3�n�%-% Ǹ��2AQ��YL!	�k\^@=�p�Ӱ��Q��xd~�o�n&�i����������?[v���>��j��o�|�!q�}�l�R��"��:T�RS$�R~n�Z�.�^��m� ��*�֌X���U�$�(=\�ƅ'�QX�?�����(�eW��.�����2�